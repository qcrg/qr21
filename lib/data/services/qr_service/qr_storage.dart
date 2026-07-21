import 'package:chirp/chirp.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:qr21/data/models/qr_data/qr_data.dart';

final log = Chirp.root.addContext({"tag": "STORAGE:QR"});

// ignore: camel_case_types
class _const {
  static const String box_name = "qr:box";
  static const String data_key = "qr:box:data";
}

class QrStorage {
  Box<QrData>? _box;

  QrStorage({this._box});

  Future<bool> has_data() async {
    await _try_init();
    return _box!.containsKey(_const.data_key);
  }

  Future<QrData?> get_data() async {
    await _try_init();
    return _box!.get(_const.data_key);
  }

  Future<void> set_data(QrData data) async {
    await _try_init();
    await _box!.put(_const.data_key, data);
  }

  Future<void> clear_data() async {
    await _try_init();
    await _box!.delete(_const.data_key);
  }

  Future<void> _try_init() async {
    _box ??= await Hive.openBox(_const.box_name);
  }
}
