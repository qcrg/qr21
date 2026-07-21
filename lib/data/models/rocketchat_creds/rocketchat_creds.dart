import "package:freezed_annotation/freezed_annotation.dart";

part "rocketchat_creds.freezed.dart";

@freezed
abstract class RocketChatCreds with _$RocketChatCreds {
  const factory RocketChatCreds({
    required String baseUrl,
    required String username,
    required String userId,
    required String authToken,
    required String botRoomId,
  }) = _RocketChatCreds;
}
