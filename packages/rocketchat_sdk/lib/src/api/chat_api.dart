import 'package:dio/dio.dart';

class RocketChatChatApi {
  final Dio _dio;

  RocketChatChatApi(this._dio);

  /// Reacts to a message with an emoji.
  /// Corresponds to `POST /api/v1/chat.react`
  Future<bool> react({
    required String messageId,
    required String emoji,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/chat.react',
        data: {
          'messageId': messageId,
          'emoji': emoji,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return true;
      } else {
        throw Exception(
          'Failed to react to message: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }
}
