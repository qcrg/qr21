import 'package:dio/dio.dart';

class RocketChatPushApi {
  final Dio _dio;

  RocketChatPushApi(this._dio);

  /// Registers a push token for the authenticated user.
  /// Corresponds to `POST /api/v1/push.token`
  Future<bool> registerToken({
    required String token,
    required String appName,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/push.token',
        data: {
          'type': 'gcm',
          'value': token,
          'appName': appName,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return true;
      } else {
        throw Exception(
          'Failed to register push token: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }
}
