import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';
import 'package:test/test.dart';
import 'test_helper.dart';

void main() {
  group('Subscriptions tests', () {
    test('get subscriptions list', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('api/v1/subscriptions.get')) {
              capturedOptions = options;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'update': [
                      {
                        '_id': 'subscription_id_123',
                        'rid': 'room_id_123',
                        'name': 'general',
                        'fname': 'General Room',
                        't': 'c',
                        'open': true,
                        'alert': true,
                        'unread': 5,
                        'userMentions': 1,
                        'groupMentions': 0,
                        'ts': '2026-05-30T00:00:00.000Z',
                        'ls': '2026-05-30T01:00:00.000Z',
                        'f': true
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

      final subscriptions = await client.subscriptions.get(updatedSince: '2026-05-30T00:00:00Z');

      expect(subscriptions, isNotEmpty);
      expect(subscriptions.length, equals(1));

      final sub = subscriptions.first;
      expect(sub.id, equals('subscription_id_123'));
      expect(sub.rid, equals('room_id_123'));
      expect(sub.name, equals('general'));
      expect(sub.fname, equals('General Room'));
      expect(sub.t, equals('c'));
      expect(sub.open, isTrue);
      expect(sub.alert, isTrue);
      expect(sub.unread, equals(5));
      expect(sub.userMentions, equals(1));
      expect(sub.groupMentions, equals(0));
      expect(sub.ts, equals('2026-05-30T00:00:00.000Z'));
      expect(sub.ls, equals('2026-05-30T01:00:00.000Z'));
      expect(sub.f, isTrue);

      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.path, contains('api/v1/subscriptions.get'));
      expect(capturedOptions!.uri.queryParameters['updatedSince'], equals('2026-05-30T00:00:00Z'));
    });

    test('mark subscription as read', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('api/v1/subscriptions.read')) {
              capturedOptions = options;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
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

      final result = await client.subscriptions.read(roomId: 'room_id_123');

      expect(result, isTrue);
      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.path, contains('api/v1/subscriptions.read'));
      expect(capturedOptions!.data['roomId'], equals('room_id_123'));
    });
  });
}
