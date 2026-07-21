import "package:freezed_annotation/freezed_annotation.dart";

part "qr_data.freezed.dart";

@freezed
abstract class QrData with _$QrData {
  const factory QrData({
    required String username,
    required String src,
    required DateTime expires,
  }) = _QrData;
}
