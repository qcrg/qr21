import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';
import 'package:test/test.dart';
import 'test_helper.dart';

void main() {
  group('Channels tests', () {
    test('get public channels list', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('api/v1/channels.list')) {
              capturedOptions = options;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'channels': [
                      {
                        '_id': 'channel_id_general',
                        'name': 'general',
                        't': 'c',
                        'msgs': 120,
                        'usersCount': 15,
                        'ts': '2026-05-30T00:00:00.000Z',
                        'u': {
                          '_id': 'user_id_creator',
                          'username': 'creator_user',
                          'name': 'Creator User',
                        }
                      }
                    ],
                    'success': true
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

      final channels = await client.channels.list(count: 10, offset: 0);

      expect(channels, isNotEmpty);
      expect(channels.length, equals(1));

      final channel = channels.first;
      expect(channel.id, equals('channel_id_general'));
      expect(channel.name, equals('general'));
      expect(channel.t, equals('c'));
      expect(channel.msgs, equals(120));
      expect(channel.usersCount, equals(15));
      expect(channel.ts, equals('2026-05-30T00:00:00.000Z'));
      
      expect(channel.creator, isNotNull);
      expect(channel.creator.id, equals('user_id_creator'));
      expect(channel.creator.username, equals('creator_user'));
      expect(channel.creator.name, equals('Creator User'));

      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.path, contains('api/v1/channels.list'));
      expect(capturedOptions!.uri.queryParameters['count'], equals('10'));
      expect(capturedOptions!.uri.queryParameters['offset'], equals('0'));
    });
  });
}
