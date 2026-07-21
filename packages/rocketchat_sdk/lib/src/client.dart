import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/src/api/auth_api.dart';
import 'package:rocketchat_sdk/src/api/channels_api.dart';
import 'package:rocketchat_sdk/src/api/chat_api.dart';
import 'package:rocketchat_sdk/src/api/dm_api.dart';
import 'package:rocketchat_sdk/src/api/misc/misc_api.dart';
import 'package:rocketchat_sdk/src/api/subscriptions_api.dart';
import 'package:rocketchat_sdk/src/api/users_api.dart';
import 'package:rocketchat_sdk/src/api/realtime_api.dart';
import 'package:rocketchat_sdk/src/api/push_api.dart';

class RocketChatClient {
  final Dio dio;
  final String baseUrl;
  String authToken;
  String userId;

  /// Authentication and profile APIs module
  late final RocketChatAuthApi auth;

  /// Direct message APIs module
  late final RocketChatDmApi dm;

  /// User management APIs module
  late final RocketChatUsersApi users;

  /// Channel and Room APIs module
  late final RocketChatChannelsApi channels;

  /// Chat APIs module
  late final RocketChatChatApi chat;

  /// Subscription and read-tracking APIs module
  late final RocketChatSubscriptionsApi subscriptions;

  /// Realtime WebSocket API module
  late final RocketChatRealtimeApi realtime;

  /// Push notification token registration APIs module
  late final RocketChatPushApi push;

  /// Miscellaneous APIs module
  late final RocketChatMiscApi misc;

  RocketChatClient({
    required this.baseUrl,
    String? authToken,
    String? userId,
    Dio? dio,
    bool enableLogging = false,
    void Function(String)? logPrinter,
  }) : dio = dio ?? Dio(),
       authToken = authToken ?? '',
       userId = userId ?? '' {
    this.dio.options.baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    _updateHeaders(this.authToken, this.userId);

    if (enableLogging) {
      // Print statements inside logging block are explicitly allowed for SDK level stdout outputs.
      // ignore: avoid_print
      final printer = logPrinter ?? (msg) => print('[RocketChatSDK] $msg');
      this.dio.interceptors.add(
        LogInterceptor(
          responseHeader: false,
          logPrint: (obj) => printer(obj.toString()),
        ),
      );
    }

    // Initialize the module APIs
    auth = RocketChatAuthApi(this.dio, _onLoginSuccess);
    dm = RocketChatDmApi(this.dio);
    users = RocketChatUsersApi(this.dio);
    channels = RocketChatChannelsApi(this.dio);
    chat = RocketChatChatApi(this.dio);
    subscriptions = RocketChatSubscriptionsApi(this.dio);
    push = RocketChatPushApi(this.dio);
    realtime = RocketChatRealtimeApi(
      baseUrl: this.baseUrl,
      logPrinter: enableLogging
          ? (logPrinter ?? (msg) => print('[RocketChatSDK] $msg'))
          : null,
    );
    misc = RocketChatMiscApi(this.dio);

    // Auto-connect if token exists
    if (this.authToken.isNotEmpty) {
      realtime
          .connect()
          .then((_) {
            realtime.login(this.authToken);
          })
          .catchError((_) {});
    }
  }

  void _onLoginSuccess(String token, String uid) {
    authToken = token;
    userId = uid;
    _updateHeaders(token, uid);

    // Auto-connect and login to Realtime API
    realtime
        .connect()
        .then((_) {
          realtime.login(token);
        })
        .catchError((_) {});
  }

  void _updateHeaders(String token, String uid) {
    dio.options.headers.addAll({
      if (token.isNotEmpty) 'X-Auth-Token': token,
      if (uid.isNotEmpty) 'X-User-Id': uid,
      'Content-Type': 'application/json',
    });
  }
}
