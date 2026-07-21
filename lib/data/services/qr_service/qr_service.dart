import 'dart:async';

import 'package:chirp/chirp.dart';
import 'package:light_result/light_result.dart';
import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/data/services/qr_service/qr_internal_sevice_state.dart';
import 'package:qr21/data/services/qr_service/qr_service_error.dart';
import 'package:qr21/data/services/qr_service/qr_storage.dart';
import 'package:qr21/data/services/qr_service/rocketchat/rocketchat_service.dart';
import 'package:rxdart/rxdart.dart';

final log = Chirp.root.addContext({"tag": "SERV:QR"});

// ignore: camel_case_types
class _const {
  static const Duration timeout = Duration(hours: 1);
  static const Duration fallback_timeout = Duration(minutes: 1);
}

class QrService {
  final RocketChatQrService rocketchat = .new();
  late StreamSubscription _rc_sub;

  final BehaviorSubject<QrData> _streamCtrl = .new();
  final QrStorage _storage;
  Timer? _timer;

  QrService({QrStorage? storage, Timer? timer})
    : _storage = storage ?? QrStorage() {
    _rc_sub = rocketchat.stateStream.listen(_on_internal_srv_state_change);
    _init_async();
  }

  Future<bool> is_authorized() async => rocketchat.is_authorized();

  Future<void> close() async {
    _timer?.cancel();
    Future.wait([
      _streamCtrl.close(),
      _rc_sub.cancel(),
    ]);
  }

  ValueStream<QrData> get dataStream => _streamCtrl.stream;

  Future<void> _init_async() async {
    log.info("Initializing QR Service...");
    final QrData? data = await _storage.get_data();

    if (data != null) {
      log.info("Use saved QR data");
      _streamCtrl.add(data);
    }
    log.info("Initializing QR service completed");
  }

  void _on_internal_srv_state_change(
    QrInternalServiceState state,
  ) {
    switch (state) {
      case .ready:
        _loop();
      case .unready:
        _storage.clear_data();
        _streamCtrl.addError(QrServiceError.unauthorized);
        _stop_loop_timer_if_needed();
    }
  }

  Future<void> _loop() async {
    log.debug("Start _loop");
    final now_ts = DateTime.now().toUtc();
    QrData? data = (await _storage.get_data()) ?? dataStream.valueOrNull;

    if (data != null && now_ts.isBefore(data.expires)) {
      log.info(
        "Data is not expired - skipping _loop",
        data: {"expires": data.expires},
      );
      _run_loop_timer(_const.timeout);
      return;
    }

    final QrServiceError? err = await _update_data();
    _run_loop_timer(err == null ? _const.timeout : _const.fallback_timeout);
    log.info("End _loop");
  }

  Future<QrServiceError?> _update_data() async {
    switch (await rocketchat.get_data()) {
      case Success(value: final data):
        log.info("Data is updated", data: {"expires": data.expires});
        await _storage.set_data(data);
        _streamCtrl.add(data);
        return null;
      case Failure(value: final error):
        log.error("Data is not updated", data: {"error": error});
        if (error == .unauthorized) {
          await _storage.clear_data();
        }
        _streamCtrl.addError(error.toQrServiceError());
        return error.toQrServiceError();
    }
  }

  void _run_loop_timer(Duration timeout) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(timeout, _loop);
    log.debug("Loop will start in '$timeout'");
  }

  void _stop_loop_timer_if_needed() {
    if (_timer == null) {
      return;
    }
    _timer?.cancel();
    _timer = null;
  }
}
