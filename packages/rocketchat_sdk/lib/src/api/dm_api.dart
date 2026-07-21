import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';
import 'package:rocketchat_sdk/src/models/create_dm_room/create_dm_room.dart';
import 'package:rocketchat_sdk/src/models/dm_room/dm_room.dart';
import 'package:rocketchat_sdk/src/models/message/message.dart';

class RocketChatDmApi {
  final Dio _dio;

  RocketChatDmApi(this._dio);

  /// Lists the direct message (DM) rooms of the authenticated user.
  /// Corresponds to `GET /api/v1/dm.list`
  Future<List<DmRoom>> list({int? offset, int? count}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'api/v1/dm.list',
        queryParameters: {
          if (offset != null) 'offset': offset,
          if (count != null) 'count': count,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        final imsList = (dataMap['ims'] as List<dynamic>?) ?? [];
        return imsList
            .map((json) => DmRoom.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load DM list: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Create or get a direct message session with another user or more than one user.
  /// Corresponds to `POST /api/v1/dm.create`
  Future<CreateDmRoom> create({
    String? username,
    List<String>? usernames,
    bool? excludeSelf,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/dm.create',
        data: {
          'username': ?username,
          'usernames': ?usernames,
          'excludeSelf': ?excludeSelf,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return CreateDmRoom.fromJson(
          dataMap['room'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          'Failed to load messages: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          throw RocketChatException.fromStatusCode(e.response!.statusCode!);

        default:
      }
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Lists messages in a specific direct message (DM) room.
  /// Corresponds to `GET /api/v1/dm.messages`
  Future<List<RocketChatMessage>> messages({
    required String roomId,
    int? offset,
    int? count,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'api/v1/dm.messages',
        queryParameters: {
          'roomId': roomId,
          if (offset != null) 'offset': offset,
          if (count != null) 'count': count,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        final msgList = (dataMap['messages'] as List<dynamic>?) ?? [];
        return msgList
            .map(
              (json) =>
                  RocketChatMessage.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(
          'Failed to load messages: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Sends a message to a direct message (DM) room.
  /// Corresponds to `POST /api/v1/chat.postMessage`
  Future<RocketChatMessage> sendMessage({
    required String roomId,
    required String text,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/chat.postMessage',
        data: {
          'roomId': roomId,
          'text': text,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        final messageJson = dataMap['message'] as Map<String, dynamic>?;
        if (messageJson != null) {
          return RocketChatMessage.fromJson(messageJson);
        } else {
          throw Exception('Message was not returned in the response');
        }
      } else {
        throw Exception(
          'Failed to send message: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }
}
