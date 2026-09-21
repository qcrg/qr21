import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/extract_context.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';

abstract interface class QrExtractorStrategy {
  Future<QrData?> extract(
    List<RocketChatMessage> messages,
    ExtractContext context,
  );
  String get name;
}
