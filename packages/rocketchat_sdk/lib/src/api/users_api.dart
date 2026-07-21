import 'package:dio/dio.dart';
import 'package:rocketchat_sdk/src/models/user/user.dart';

class RocketChatUsersApi {
  final Dio _dio;

  RocketChatUsersApi(this._dio);

  /// Lists all the users in the workspace.
  /// Corresponds to `GET /api/v1/users.list`
  Future<List<RocketChatUser>> list({int? offset, int? count}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'api/v1/users.list',
        queryParameters: {
          if (offset != null) 'offset': offset,
          if (count != null) 'count': count,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        final usersList = (dataMap['users'] as List<dynamic>?) ?? [];
        return usersList
            .map(
              (json) => RocketChatUser.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(
          'Failed to load users: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Gets a specific user's info by their ID.
  /// Corresponds to `GET /api/v1/users.info`
  Future<RocketChatUser> info({required String userId}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'api/v1/users.info',
        queryParameters: {
          'userId': userId,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return RocketChatUser.fromJson(dataMap['user'] as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to load user info: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Creates a new user in the workspace.
  /// Corresponds to `POST /api/v1/users.create`
  Future<RocketChatUser> create({
    required String email,
    required String name,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/users.create',
        data: {
          'email': email,
          'name': name,
          'username': username,
          'password': password,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return RocketChatUser.fromJson(dataMap['user'] as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to create user: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Deletes an existing user in the workspace.
  /// Corresponds to `POST /api/v1/users.delete`
  Future<bool> delete({required String userId}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'api/v1/users.delete',
        data: {
          'userId': userId,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return true;
      } else {
        throw Exception(
          'Failed to delete user: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Views a user's avatar URL by resolving all 3xx redirects to get the final image URL.
  /// Substitutes 'localhost' or '127.0.0.1' with the client's baseUrl host/port.
  ///
  /// Corresponds to `GET /api/v1/users.getAvatar`
  Future<String> getAvatar({
    String? userId,
  }) async {
    try {
      final base = _dio.options.baseUrl;
      final separator = base.endsWith('/') ? '' : '/';
      final queryParam = userId != null ? '?userId=$userId' : '';
      var currentUrl = '$base${separator}api/v1/users.getAvatar$queryParam';

      // Follow up to 5 redirects manually to resolve localhost/127.0.0.1 in intermediate and final URLs
      for (var i = 0; i < 5; i++) {
        final response = await _dio.get<void>(
          currentUrl,
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status != null && status < 400; // Capture 2xx and 3xx
            },
          ),
        );

        var redirectUrl = response.headers.value('location') ?? '';
        if (redirectUrl.isEmpty) {
          // No more redirects, this is the final URL
          break;
        }

        // Handle relative URL redirects
        if (!redirectUrl.startsWith('http://') && !redirectUrl.startsWith('https://')) {
          final separator = base.endsWith('/') || redirectUrl.startsWith('/') ? '' : '/';
          redirectUrl = '$base$separator$redirectUrl';
        } else {
          // Handle absolute URL redirects: substitute localhost or 127.0.0.1 with client's actual baseUrl host/port
          final redirectUri = Uri.parse(redirectUrl);
          if (redirectUri.host == 'localhost' || redirectUri.host == '127.0.0.1') {
            final clientUri = Uri.parse(base);
            redirectUrl = redirectUri.replace(
              scheme: clientUri.scheme,
              host: clientUri.host,
              port: clientUri.port,
            ).toString();
          }
        }

        currentUrl = redirectUrl;
      }

      return currentUrl;
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }

  /// Gets a user's presence status.
  /// Corresponds to `GET /api/v1/users.getPresence`
  Future<String> getPresence({String? userId, String? username}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'api/v1/users.getPresence',
        queryParameters: {
          if (userId != null) 'userId': userId,
          if (username != null) 'username': username,
        },
      );

      final dataMap = response.data;
      if (response.statusCode == 200 &&
          dataMap != null &&
          dataMap['success'] == true) {
        return dataMap['status'] as String? ?? 'offline';
      } else {
        throw Exception(
          'Failed to get presence: ${dataMap?['error'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception('HTTP Error: ${e.message}');
    }
  }
}
