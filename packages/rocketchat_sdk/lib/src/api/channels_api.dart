import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/src/models/channel_room/channel_room.dart';
import 'package:rocketchat_sdk/src/models/message/message.dart';

class RocketChatChannelsApi {
  final Dio _dio;

  RocketChatChannelsApi(this._dio);

  /// Lists all public channels in the workspace.
  /// Corresponds to `GET /api/v1/channels.list`
  Future<List<ChannelRoom>> list({int? offset, int? count}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'api/v1/channels.list',
        queryParameters: {
          if (offset != null) 'offset': offset,
          if (count != null) 'count': count,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        final channelsList = (dataMap['channels'] as List<dynamic>?) ?? [];
        return channelsList
            .map((json) => ChannelRoom.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load channels: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Creates a new public channel.
  /// Corresponds to `POST /api/v1/channels.create`
  Future<ChannelRoom> create({
    required String name,
    bool readOnly = false,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/channels.create',
        data: {
          'name': name,
          'readOnly': readOnly,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return ChannelRoom.fromJson(dataMap['channel'] as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to create channel: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Joins an existing public channel.
  /// Corresponds to `POST /api/v1/channels.join`
  Future<bool> join({required String roomId}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/channels.join',
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
          'Failed to join channel: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Leaves a public channel.
  /// Corresponds to `POST /api/v1/channels.leave`
  Future<bool> leave({required String roomId}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/channels.leave',
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
          'Failed to leave channel: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Retrieves messages history from a public channel.
  /// Corresponds to `GET /api/v1/channels.history`
  Future<List<RocketChatMessage>> history({
    required String roomId,
    int? offset,
    int? count,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'api/v1/channels.history',
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
          'Failed to load channel history: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Gets public channel info by room ID.
  /// Corresponds to `GET /api/v1/channels.info`
  Future<ChannelRoom> info({required String roomId}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'api/v1/channels.info',
        queryParameters: {
          'roomId': roomId,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return ChannelRoom.fromJson(dataMap['channel'] as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to load channel info: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }
}
