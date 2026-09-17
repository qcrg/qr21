import 'package:chirp/chirp.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/data/services/secure_storage/secure_storage.dart';

// ignore: camel_case_types
class _const {
  static const String box_name = "qr:box";
  static const String data_key = "qr:box:data";
  static const String ss_qrdata_key = "qr:ss:qr_data";
}

final _log = Chirp.root.addContext({"tag": "QR_STORAGE"});

class QrStorage {
  Box<QrData>? _box;
  final SecureStorage _sstorage;

  QrStorage({this._box, SecureStorage? sstorage})
    : _sstorage = sstorage ?? .new();

  Future<bool> has_data() async {
    await _try_init();
    return _box!.containsKey(_const.data_key);
  }

  Future<QrData?> get_data() async {
    await _try_init();
    final res = _box!.get(_const.data_key);
    if (res != null && res.isSrcInSecureScope()) {
      return _get_secured_data(res, _sstorage);
    }
    return res;
  }

  Future<void> set_data(QrData data) async {
    await _try_init();
    await _box!.put(_const.data_key, data.filtered);
    await _sstorage.write(_const.ss_qrdata_key, data.src);
  }

  Future<void> clear_data() async {
    await _try_init();
    await _box!.delete(_const.data_key);
    await _sstorage.delete(_const.ss_qrdata_key);
  }

  Future<void> _try_init() async {
    _box ??= await Hive.openBox(_const.box_name);
  }
}

Future<QrData> _get_secured_data(QrData data, SecureStorage sstorage) async {
  final src = await sstorage.read(_const.ss_qrdata_key);
  if (src == null) {
    _log.wtf("'QrCode.src' and qr-data from secure storage is empty");
    return data;
  }
  return data.copyWith(src: src);
}
