import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/extract_context.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/strategies/strategy.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';

class MergedBase64 implements QrExtractorStrategy {
  @override
  Future<QrData?> extract(
    List<RocketChatMessage> messages,
    ExtractContext _,
  ) async {
    for (final msg in messages) {
      final QrData? qr = _single_extract(msg);
      if (qr != null) {
        return qr;
      }
    }
    return null;
  }

  @override
  String get name => "MergedBase64";
}

final _date_pattern = RegExp(r'[0-3][0-9]\.[0-1][0-9]\.[0-9]{4}');
final _qr_pattern = RegExp(r'\[QR code\]\((.+)\)');

QrData? _single_extract(RocketChatMessage msg) {
  final text = msg.msg;
  String? src = _extract_qr_data(text);
  DateTime? expires = _extract_expiration_timestamp(text);
  if (src == null || expires == null) {
    return null;
  }
  return QrData(
    username: "",
    src: src,
    expires: expires,
  );
}

String? _extract_qr_data(String text) {
  final match = _qr_pattern.firstMatch(text);
  if (match == null) {
    return null;
  }
  return match.group(0)!;
}

DateTime? _extract_expiration_timestamp(String text) {
  final match = _date_pattern.firstMatch(text);
  if (match == null) {
    return null;
  }
  match[0];
  final ds = match.group(0)!.split('.');
  final expires = DateTime.utc(
    int.parse(ds[2]),
    int.parse(ds[1]),
    int.parse(ds[0]),
  );
  return expires;
}
