import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/src/models/subscription/subscription.dart';

class RocketChatSubscriptionsApi {
  final Dio _dio;

  RocketChatSubscriptionsApi(this._dio);

  /// Lists the subscriptions of the authenticated user.
  /// Corresponds to `GET /api/v1/subscriptions.get`
  Future<List<RocketChatSubscription>> get({String? updatedSince}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'api/v1/subscriptions.get',
        queryParameters: {
          if (updatedSince != null) 'updatedSince': updatedSince,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        final updateList = (dataMap['update'] as List<dynamic>?) ?? [];
        return updateList
            .map((json) => RocketChatSubscription.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load subscriptions: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Marks a specific room subscription as read.
  /// Corresponds to `POST /api/v1/subscriptions.read`
  Future<bool> read({required String roomId}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/subscriptions.read',
        data: {
          'roomId': roomId,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return true;
      } else {
        throw Exception(
          'Failed to mark subscription as read: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }
}
