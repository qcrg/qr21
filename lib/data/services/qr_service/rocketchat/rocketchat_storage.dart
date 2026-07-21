import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:qr21/data/models/rocketchat_creds/rocketchat_creds.dart';

// ignore: camel_case_types
class _const {
  static const String box_name = "rc:box";
  static const String creds_key = "rc:box:creds";
}

class RocketChatStorage {
  Box<RocketChatCreds>? _box;

  RocketChatStorage({this._box});

  Future<bool> has_creds() async {
    await _try_init();
    return _box!.containsKey(_const.creds_key);
  }

  Future<RocketChatCreds?> get_creds() async {
    await _try_init();
    return _box!.get(_const.creds_key);
  }

  Future<void> set_creds(RocketChatCreds creds) async {
    await _try_init();
    await _box!.put(_const.creds_key, creds);
  }

  Future<void> clear_creds() async {
    await _try_init();
    await _box!.delete(_const.creds_key);
  }

  Future<void> _try_init() async {
    _box ??= await Hive.openBox(_const.box_name);
  }
}
