import "package:freezed_annotation/freezed_annotation.dart";

part "qr_data.freezed.dart";

// ignore: camel_case_types
class _const {
  static const String src_in_secure_scope_value = "<<qr-code-in-secure-scope>>";
}

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

  bool isSrcInSecureScope() {
    return src == _const.src_in_secure_scope_value;
  }

  QrData get filtered => this.copyWith(src: _const.src_in_secure_scope_value);
}
