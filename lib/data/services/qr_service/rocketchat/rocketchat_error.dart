import 'package:qr21/data/services/qr_service/qr_service_error.dart';

enum RocketChatError {
  serverNotFound,
  incorrectServer,
  incorrectCredentials,
  botNotFound,
  unauthorized,
  qrNotGenerated;

  QrServiceError toQrServiceError() {
    switch (this) {
      case .serverNotFound:
        return .serverNotFound;
      case .unauthorized:
        return .unauthorized;
      case .qrNotGenerated:
        return .qrNotGenerated;
      default:
        return .unknown;
    }
  }
}
