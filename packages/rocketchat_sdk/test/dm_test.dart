import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';
import 'package:test/test.dart';
import 'test_helper.dart';

void main() {
  group('DM Rooms tests', () {
    test('get DM rooms', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('api/v1/dm.list')) {
              capturedOptions = options;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'ims': [
                      {
                        '_id': 'room_id_123',
                        't': 'd',
                        'usernames': ['alice', 'bob'],
                        'usersCount': 2,
                        'msgs': 42,
                        'ts': '2026-05-30T00:00:00.000Z',
                        'uids': ['uid_alice', 'uid_bob'],
                      },
                    ],
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

      final dms = await client.dm.list(count: 10, offset: 0);

      expect(dms, isNotEmpty);
      expect(dms.length, equals(1));

      final room = dms.first;
      expect(room.id, equals('room_id_123'));
      expect(room.t, equals('d'));
      expect(room.usernames, containsAll(['alice', 'bob']));
      expect(room.usersCount, equals(2));
      expect(room.msgs, equals(42));
      expect(room.ts, equals('2026-05-30T00:00:00.000Z'));
      expect(room.uids, containsAll(['uid_alice', 'uid_bob']));

      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.path, contains('api/v1/dm.list'));
      expect(capturedOptions!.uri.queryParameters['count'], equals('10'));
      expect(capturedOptions!.uri.queryParameters['offset'], equals('0'));
    });

    test('create DM room', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('api/v1/dm.create')) {
              capturedOptions = options;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'room': {
                      't': 'd',
                      'rid': 'room_id_123',
                      'usernames': ['alice', 'bob'],
                    },
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

      final room = await client.dm.create(username: 'alice');

      expect(room.id, equals('room_id_123'));
      expect(room.t, equals('d'));
      expect(room.usernames, containsAll(['alice', 'bob']));

      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.path, contains('api/v1/dm.create'));
      expect(
        (capturedOptions!.data as Map<String, dynamic>)['username'],
        equals('alice'),
      );
    });
  });
}
