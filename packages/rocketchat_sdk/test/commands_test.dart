import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';
import 'package:test/test.dart';
import 'test_helper.dart';

void main() {
  group('Commands tests', () {
    test('run', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('api/v1/commands.run')) {
              capturedOptions = options;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                  },
                ),
              );
            } else {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                ),
              );
            }
          },
        ),
      );

      final client = RocketChatClient(
        baseUrl: testBaseUrl,
        authToken: testAuthToken,
        userId: testUserId,
        dio: dio,
      );

      await client.misc.commands.run(
        command: 'test_user_123',
        roomId: 'test_room_123',
      );

      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.path, contains('api/v1/commands.run'));
      expect(capturedOptions!.data['command'], equals('test_user_123'));
      expect(capturedOptions!.data['roomId'], equals('test_room_123'));
    });
  });
}
