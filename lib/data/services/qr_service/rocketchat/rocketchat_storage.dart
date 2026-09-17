import 'package:chirp/chirp.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:qr21/data/models/rocketchat_creds/rocketchat_creds.dart';
import 'package:qr21/data/services/secure_storage/secure_storage.dart';

final _log = Chirp.root.addContext({"tag": "RC:STORAGE"});

// ignore: camel_case_types
class _const {
  static const String box_name = "rc:box";
  static const String creds_key = "rc:box:creds";
  static const String user_secured_auth_token_key = "rc:ss:auth_token";
}

class RocketChatStorage {
  Box<RocketChatCreds>? _box;
  final SecureStorage _sstorage;

  RocketChatStorage({this._box, SecureStorage? sstorage})
    : _sstorage = sstorage ?? .new();

  Future<bool> has_creds() async {
    await _try_init();
    return _box!.containsKey(_const.creds_key);
  }

  Future<RocketChatCreds?> get_creds() async {
    await _try_init();
    final creds = _box!.get(_const.creds_key);
    if (creds != null && creds.isAuthTokenInSecureScope()) {
      return _get_secured_creds(creds, _sstorage);
    }
    return creds;
  }

  Future<void> set_creds(RocketChatCreds creds) async {
    await _try_init();
    await _box!.put(_const.creds_key, creds.filtered);
    await _sstorage.write(_const.user_secured_auth_token_key, creds.authToken);
  }

  Future<void> clear_creds() async {
    await _try_init();
    await _box!.delete(_const.creds_key);
    await _sstorage.delete(_const.user_secured_auth_token_key);
  }

  Future<void> _try_init() async {
    _box ??= await Hive.openBox(_const.box_name);
  }
}

Future<RocketChatCreds> _get_secured_creds(
  RocketChatCreds creds,
  SecureStorage sstorage,
) async {
  final auth_token = await sstorage.read(_const.user_secured_auth_token_key);
  if (auth_token == null) {
    _log.wtf("'QrCode.src' and qr-data from secure storage is empty");
    return creds;
  }
  return creds.copyWith(authToken: auth_token);
}
