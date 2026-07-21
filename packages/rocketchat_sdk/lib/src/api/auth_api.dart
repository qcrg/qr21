import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/src/exceptions/general.dart';
import 'package:rocketchat_sdk/src/models/rocketchat_login_data/rocketchat_login_data.dart';
import 'package:rocketchat_sdk/src/models/user/user.dart';

class RocketChatAuthApi {
  final Dio _dio;
  final void Function(String token, String userId) _onLoginSuccess;

  RocketChatAuthApi(this._dio, this._onLoginSuccess);

  /// Performs a login request to Rocket.Chat using username and password.
  /// Corresponds to `POST /api/v1/login`
  Future<RocketChatLoginData> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/login',
        data: {'user': username, 'password': password},
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['status'] == 'success') {
        final data = dataMap['data'] as Map<String, dynamic>;
        final loginData = RocketChatLoginData(
          authToken: data['authToken'] as String? ?? '',
          userId: data['userId'] as String? ?? '',
        );

        // Update the main client's authentication headers
        _onLoginSuccess(loginData.authToken, loginData.userId);

        return loginData;
      } else {
        throw Exception(
          'Login failed: ${dataMap?['message'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          throw RocketChatException.fromStatusCode(e.response!.statusCode!);

        default:
      }
      throw Exception('HTTP Error: type=${e.type} ${e.message}');
    }
  }

  /// Performs a logout request to Rocket.Chat.
  /// Corresponds to `POST /api/v1/logout`
  Future<bool> logout() async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('api/v1/logout');
      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['status'] == 'success') {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Gets the authenticated user's details.
  /// Corresponds to `GET /api/v1/me`
  Future<RocketChatUser> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('api/v1/me');
      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return RocketChatUser.fromJson(dataMap);
      } else {
        throw Exception(
          'Failed to get profile: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }
}
