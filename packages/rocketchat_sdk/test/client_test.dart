import 'package:rocketchat_sdk/rocketchat_sdk.dart';
import 'package:test/test.dart';
import 'test_helper.dart';

void main() {
  group('RocketChatClient tests', () {
    test('Can instantiate RocketChatClient', () {
      final client = RocketChatClient(
        baseUrl: testBaseUrl,
        authToken: testAuthToken,
        userId: testUserId,
      );
      expect(client.baseUrl, equals(testBaseUrl));
      expect(client.authToken, equals(testAuthToken));
      expect(client.userId, equals(testUserId));
      expect(client.dm, isNotNull);
    });
  });
}
