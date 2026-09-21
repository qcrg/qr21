import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/strategies/merged_base64.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/strategies/splitted_attachment.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/strategies/splitted_base64.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/strategies/strategy.dart';

final List<QrExtractorStrategy> qr_extractor_default_strategies = [
  MergedBase64(),
  SplittedBase64(),
  SplittedAttachment(),
];
