import "package:freezed_annotation/freezed_annotation.dart";

part "rocketchat_creds.freezed.dart";

// ignore: camel_case_types
class _const {
  static const String auth_token_in_secure_scope_value =
      "<<auth-token-is-secure-scope>>";
}

@freezed
abstract class RocketChatCreds with _$RocketChatCreds {
  const RocketChatCreds._();
  const factory RocketChatCreds({
    required String baseUrl,
    required String username,
    required String userId,
    required String authToken,
  }) = _RocketChatCreds;

  bool isAuthTokenInSecureScope() {
    return authToken == _const.auth_token_in_secure_scope_value;
  }

  RocketChatCreds get filtered =>
      this.copyWith(authToken: _const.auth_token_in_secure_scope_value);
}
