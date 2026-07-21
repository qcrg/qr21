/// Exception for handling RocketChat API errors
class RocketChatException implements Exception {
  final String message;
  final RocketChatErrorType type;

  const RocketChatException(
    this.message,
    this.type,
  );

  /// 400 Bad Request
  factory RocketChatException.badRequest() {
    return const RocketChatException(
      'The request could not be processed due to missing or invalid parameters. Check the request format and required fields.',
      RocketChatErrorType.badRequest,
    );
  }

  /// 401 Unauthorized
  factory RocketChatException.unauthorized() {
    return const RocketChatException(
      'Authentication failed because the user ID or token is invalid or expired. Obtain a valid token using the authentication endpoint.',
      RocketChatErrorType.unauthorized,
    );
  }

  /// 403 Forbidden
  factory RocketChatException.forbidden() {
    return const RocketChatException(
      'The authenticated user does not have permission to perform this action. Verify the assigned roles and permissions.',
      RocketChatErrorType.forbidden,
    );
  }

  /// 404 Not Found
  factory RocketChatException.notFound() {
    return const RocketChatException(
      'The requested resource could not be found. Check the endpoint URL or resource identifier.',
      RocketChatErrorType.notFound,
    );
  }

  /// 409 Conflict
  factory RocketChatException.conflict() {
    return const RocketChatException(
      'The request could not be completed due to a conflict with the current resource state (for example, trying to create a duplicate record).',
      RocketChatErrorType.conflict,
    );
  }

  /// 429 Too Many Requests
  factory RocketChatException.tooManyRequests() {
    return const RocketChatException(
      'The client has sent too many requests in a given period. Wait or reduce the request rate before retrying.',
      RocketChatErrorType.tooManyRequests,
    );
  }

  /// 500 Internal Server Error
  factory RocketChatException.internalServerError() {
    return const RocketChatException(
      'The server encountered an unexpected condition. Try again later or check the server logs for more information.',
      RocketChatErrorType.internalServerError,
    );
  }

  /// 503 Service Unavailable
  factory RocketChatException.serviceUnavailable() {
    return const RocketChatException(
      'The server is temporarily unavailable or undergoing maintenance. Retry the request after some time.',
      RocketChatErrorType.serviceUnavailable,
    );
  }

  /// Creates an exception based on HTTP status code
  factory RocketChatException.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return RocketChatException.badRequest();
      case 401:
        return RocketChatException.unauthorized();
      case 403:
        return RocketChatException.forbidden();
      case 404:
        return RocketChatException.notFound();
      case 409:
        return RocketChatException.conflict();
      case 429:
        return RocketChatException.tooManyRequests();
      case 500:
        return RocketChatException.internalServerError();
      case 503:
        return RocketChatException.serviceUnavailable();
      default:
        return RocketChatException(
          'An unknown error occurred with status code $statusCode',
          RocketChatErrorType.unknown,
        );
    }
  }

  /// Checks if the error is related to authorization
  bool get isAuthError =>
      type == RocketChatErrorType.unauthorized ||
      type == RocketChatErrorType.forbidden;

  /// Checks if the error is a client error (4xx)
  bool get isClientError =>
      type == RocketChatErrorType.badRequest ||
      type == RocketChatErrorType.unauthorized ||
      type == RocketChatErrorType.forbidden ||
      type == RocketChatErrorType.notFound ||
      type == RocketChatErrorType.conflict ||
      type == RocketChatErrorType.tooManyRequests;

  /// Checks if the error is a server error (5xx)
  bool get isServerError =>
      type == RocketChatErrorType.internalServerError ||
      type == RocketChatErrorType.serviceUnavailable;

  @override
  String toString() {
    return "RocketChatException(type=$type, message='$message'";
  }
}

/// Enum of RocketChat API error types
enum RocketChatErrorType {
  /// 400 Bad Request
  badRequest,

  /// 401 Unauthorized
  unauthorized,

  /// 403 Forbidden
  forbidden,

  /// 404 Not Found
  notFound,

  /// 409 Conflict
  conflict,

  /// 429 Too Many Requests
  tooManyRequests,

  /// 500 Internal Server Error
  internalServerError,

  /// 503 Service Unavailable
  serviceUnavailable,

  /// Unknown status
  unknown,
}
