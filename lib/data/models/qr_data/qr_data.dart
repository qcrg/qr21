import "package:freezed_annotation/freezed_annotation.dart";

part "qr_data.freezed.dart";

@freezed
abstract class QrData with _$QrData {
  const QrData._();
  const factory QrData({
    required String username,
    required String src,
    required DateTime expires,
  }) = _QrData;

  bool isExpired([DateTime? now]) {
    final now_date = now ?? DateTime.now().toUtc();
    return !now_date.isBefore(this.expires);
  }
}
