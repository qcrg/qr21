import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/extract_context.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/strategies/strategy.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';

enum _State {
  readExpirationDate,
  readQr,
}

class SplittedBase64 implements QrExtractorStrategy {
  @override
  Future<QrData?> extract(
    List<RocketChatMessage> messages,
    ExtractContext _,
  ) async {
    _State state = .readExpirationDate;
    DateTime? expires;
    String? qr_data;
    for (final msg in messages) {
      switch (state) {
        case .readExpirationDate:
          expires = _extract_expiration_timestamp(msg.msg);
          if (expires != null) {
            state = .readQr;
          }

        case .readQr:
          qr_data = _extract_qr_data(msg.msg);
          if (qr_data == null) {
            state = .readExpirationDate;
          } else {
            return QrData(
              username: "",
              expires: expires!,
              src: qr_data,
            );
          }
      }
    }
    return null;
  }

  @override
  String get name => "SplittedBase64";
}

final _date_pattern = RegExp(r'[0-3][0-9]\.[0-1][0-9]\.[0-9]{4}');
final _qr_pattern = RegExp(r'\[QR code\]\((.+)\)');

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
