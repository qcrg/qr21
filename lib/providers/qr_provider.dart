import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/data/services/qr_service/qr_service.dart';
import 'package:qr21/data/services/qr_service/qr_service_error.dart';

class QrProvider extends ChangeNotifier {
  final QrService service;
  late StreamSubscription _sub;
  QrData? _data;
  QrServiceError? _error;

  QrData? get data => _data;
  QrServiceError? get error => _error;

  QrProvider({QrService? service}) : this.service = service ?? QrService() {
    _sub = this.service.dataStream.listen(
      _set_data,
      onError: (Object obj_err) {
        final err = obj_err as QrServiceError;
        if (err == .unauthorized) {
          _set_data(null);
        }
        _set_error(err);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
    service.close();
  }

  void _set_data(QrData? data) {
    if (_data == data) return;
    _data = data;
    notifyListeners();
  }

  void _set_error(QrServiceError? err) {
    if (_error == err) return;
    _error = err;
    notifyListeners();
  }
}
