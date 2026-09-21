import 'package:chirp/chirp.dart';
import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/extract_context.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/strategies/strategy.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/default_strategies.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';

final _log = Chirp.root.addContext({"tag": "RC:QR_EXTRACTOR"});

class QrExtractor {
  final List<QrExtractorStrategy> _strategies;

  QrExtractor({List<QrExtractorStrategy>? strategies})
    : _strategies = strategies ?? qr_extractor_default_strategies {
    if (_strategies.isEmpty) {
      _log.wtf("Strategies is empty");
    }
  }

  // not extracting username
  Future<QrData?> extract(
    List<RocketChatMessage> msgs,
    ExtractContext context,
  ) async {
    for (final strategy in _strategies) {
      final QrData? qr = await strategy.extract(msgs, context);
      if (qr != null) return qr;
    }
    return null;
  }
}
