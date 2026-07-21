import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/src/api/misc/commands_api.dart';
import 'package:rocketchat_sdk/src/exceptions/general.dart';
import 'package:rocketchat_sdk/src/models/misc_info/misc_info.dart';

class RocketChatMiscApi {
  final Dio _dio;

  /// Commands APIs module
  late final RocketChatCommandsApi commands;

  RocketChatMiscApi(this._dio) {
    commands = RocketChatCommandsApi(_dio);
  }

  /// Get information about RocketChat server.
  /// Corresponds to `GET /api/info`
  Future<MiscInfo> info() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'api/info',
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] as bool) {
        return MiscInfo.fromJson(dataMap);
      }
      throw Exception(
        'Failed to retrive information about server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw RocketChatException.fromStatusCode(e.response!.statusCode!);
      }
      throw Exception('HTTP Error: ${e.message}');
    }
  }
}
