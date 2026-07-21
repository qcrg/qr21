import 'package:freezed_annotation/freezed_annotation.dart';

part 'rocketchat_login_data.freezed.dart';
part 'rocketchat_login_data.g.dart';

@freezed
@immutable
abstract class RocketChatLoginData with _$RocketChatLoginData {
  factory RocketChatLoginData({
    required String authToken,
    required String userId,
  }) = _RocketChatLoginData;

  factory RocketChatLoginData.fromJson(Map<String, dynamic> json) =>
      _$RocketChatLoginDataFromJson(json);
}
