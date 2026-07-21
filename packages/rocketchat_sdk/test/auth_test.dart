import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';
import 'package:test/test.dart';
import 'test_helper.dart';

void main() {
  group('Auth tests', () {
    test('login', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('api/v1/login')) {
              capturedOptions = options;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'status': 'success',
                    'data': {
                      'authToken': 'new_auth_token_xyz',
                      'userId': 'new_user_id_xyz',
                    }
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
        dio: dio,
      );

      final loginData = await client.auth.login(
        username: 'myuser',
        password: 'mypassword',
      );

      expect(loginData.authToken, equals('new_auth_token_xyz'));
      expect(loginData.userId, equals('new_user_id_xyz'));

      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.path, contains('api/v1/login'));
      expect(capturedOptions!.data['user'], equals('myuser'));
      expect(capturedOptions!.data['password'], equals('mypassword'));

      // Verify that login automatically updates the headers for subsequent requests
      expect(client.authToken, equals('new_auth_token_xyz'));
      expect(client.userId, equals('new_user_id_xyz'));
      expect(client.dio.options.headers['X-Auth-Token'], equals('new_auth_token_xyz'));
      expect(client.dio.options.headers['X-User-Id'], equals('new_user_id_xyz'));
    });

    test('logout', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('api/v1/logout')) {
              capturedOptions = options;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'status': 'success'
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

      final result = await client.auth.logout();

      expect(result, isTrue);
      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.path, contains('api/v1/logout'));
    });

    test('me profile details', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('api/v1/me')) {
              capturedOptions = options;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    '_id': 'my_authenticated_uid',
                    'username': 'auth_user_username',
                    'name': 'Authenticated User Name',
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

      final myself = await client.auth.me();

      expect(myself.id, equals('my_authenticated_uid'));
      expect(myself.username, equals('auth_user_username'));
      expect(myself.name, equals('Authenticated User Name'));

      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.path, contains('api/v1/me'));
    });
  });
}
