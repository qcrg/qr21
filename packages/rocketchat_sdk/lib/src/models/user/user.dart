import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@immutable
abstract class RocketChatUser with _$RocketChatUser {
  factory RocketChatUser({
    @JsonKey(name: '_id') required String id,
    required String username,
    String? name,
  }) = _RocketChatUser;

  factory RocketChatUser.fromJson(Map<String, dynamic> json) =>
      _$RocketChatUserFromJson(json);
}
