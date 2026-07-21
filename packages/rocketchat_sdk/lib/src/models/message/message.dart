import 'package:freezed_annotation/freezed_annotation.dart';
import '../user/user.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
@immutable
abstract class RocketChatMessage with _$RocketChatMessage {
  factory RocketChatMessage({
    @JsonKey(name: '_id') required String id,
    required String rid,
    required String msg,
    required String ts,
    @JsonKey(name: 'u') required RocketChatUser sender,
    Map<String, dynamic>? reactions,
  }) = _RocketChatMessage;

  factory RocketChatMessage.fromJson(Map<String, dynamic> json) =>
      _$RocketChatMessageFromJson(json);
}
