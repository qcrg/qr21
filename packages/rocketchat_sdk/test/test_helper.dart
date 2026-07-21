import 'dart:io';

Map<String, String> _loadEnv() {
  final env = <String, String>{};
  final file = File('.env');
  if (file.existsSync()) {
    final lines = file.readAsLinesSync();
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final parts = line.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim();
        if ((value.startsWith("'") && value.endsWith("'")) ||
            (value.startsWith('"') && value.endsWith('"'))) {
          env[key] = value.substring(1, value.length - 1);
        } else {
          env[key] = value;
        }
      }
    }
  }
  return env;
}

final _env = _loadEnv();

final String testBaseUrl = Platform.environment['ROCKETCHAT_BASE_URL'] ?? _env['ROCKETCHAT_BASE_URL'] ?? 'https://chat.example.com';
final String testAuthToken = Platform.environment['ROCKETCHAT_AUTH_TOKEN'] ?? _env['ROCKETCHAT_AUTH_TOKEN'] ?? 'token';
final String testUserId = Platform.environment['ROCKETCHAT_USER_ID'] ?? _env['ROCKETCHAT_USER_ID'] ?? 'uid';
