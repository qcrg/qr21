import 'dart:async';
import 'dart:convert';

import 'package:rocketchat_sdk/src/models/message/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum UserPresenceStatus { offline, online, away, busy, unknown }

class UserPresenceEvent {
  final String username;
  final UserPresenceStatus status;

  UserPresenceEvent(this.username, this.status);
}

class RocketChatRealtimeApi {
  final String baseUrl;
  final void Function(String)? logPrinter;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  
  final _presenceController = StreamController<UserPresenceEvent>.broadcast();
  Stream<UserPresenceEvent> get presenceStream => _presenceController.stream;

  final _messageController = StreamController<RocketChatMessage>.broadcast();
  Stream<RocketChatMessage> get messageStream => _messageController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;
  
  String? _pendingLoginToken;
  String? _resumeToken;
  Timer? _reconnectTimer;
  bool _isReconnecting = false;
  final _activeRoomSubs = <String>{};

  RocketChatRealtimeApi({required this.baseUrl, this.logPrinter});

  void _log(String message) {
    logPrinter?.call('[Realtime] $message');
  }

  /// Connects to the Realtime API WebSocket
  Future<void> connect() async {
    if (_isConnected) return;
    
    _log('Connecting to Realtime API...');

    final uri = Uri.parse(baseUrl);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final host = uri.host;
    final port = uri.port != 0 && uri.port != 80 && uri.port != 443 ? ':${uri.port}' : '';
    final path = uri.path.endsWith('/') ? uri.path.substring(0, uri.path.length - 1) : uri.path;
    
    final wsUrl = '$scheme://$host$port$path/websocket';
    _log('WebSocket URL: $wsUrl');
    
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    
    _subscription = _channel?.stream.listen(
      (data) {
        if (data is String) {
          _handleMessage(data);
        }
      },
      onError: (dynamic error) {
        _log('WebSocket Error: $error');
        _isConnected = false;
        _handleDisconnect();
      },
      onDone: () {
        _log('WebSocket Closed');
        _isConnected = false;
        _handleDisconnect();
      },
    );

    // Send connect message
    _send({
      'msg': 'connect',
      'version': '1',
      'support': ['1']
    });
  }

  /// Logins using a resume token (REST auth token)
  void login(String resumeToken) {
    _resumeToken = resumeToken;
    if (!_isConnected) {
      _pendingLoginToken = resumeToken;
      _log('Queued login until connected');
      return;
    }
    _pendingLoginToken = null;
    _send({
      'msg': 'method',
      'method': 'login',
      'params': [
        {'resume': resumeToken}
      ],
      'id': 'login-1'
    });
  }

  void _handleDisconnect() {
    if (_isReconnecting) return;
    if (_resumeToken == null) {
      _log('No login token saved, skipping auto-reconnect');
      return;
    }

    _isReconnecting = true;
    _log('Scheduling auto-reconnect in 3 seconds...');
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () async {
      _isReconnecting = false;
      _log('Attempting to reconnect...');
      try {
        await connect();
        if (_resumeToken != null) {
          login(_resumeToken!);
        }
      } on Object catch (e) {
        _log('Reconnection attempt failed: $e');
        _handleDisconnect();
      }
    });
  }

  /// Subscribes to the global user presence stream
  void subscribeToUserPresence() {
    _send({
      'msg': 'sub',
      'id': 'sub-presence',
      'name': 'stream-user-presence',
      'params': ['', false]
    });
  }

  /// Subscribes to the user's message stream globally
  void subscribeToMyMessages() {
    _send({
      'msg': 'sub',
      'id': 'sub-my-messages',
      'name': 'stream-room-messages',
      'params': ['__my_messages__', false]
    });
  }

  /// Subscribes to dynamic room messages
  void subscribeToRoomMessages(String roomId) {
    _activeRoomSubs.add(roomId);
    if (_isConnected) {
      _log('Subscribing to room messages: $roomId');
      _send({
        'msg': 'sub',
        'id': 'sub-msg-$roomId',
        'name': 'stream-room-messages',
        'params': [roomId, false]
      });
    }
  }

  /// Unsubscribes from dynamic room messages
  void unsubscribeFromRoomMessages(String roomId) {
    _activeRoomSubs.remove(roomId);
    if (_isConnected) {
      _log('Unsubscribing from room messages: $roomId');
      _send({
        'msg': 'unsub',
        'id': 'sub-msg-$roomId',
      });
    }
  }

  void _send(Map<String, dynamic> payload) {
    if (_channel != null) {
      final msg = jsonEncode(payload);
      _log('SEND: $msg');
      _channel!.sink.add(msg);
    }
  }

  Map<String, dynamic> _normalizeMessageJson(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);
    if (copy['ts'] is Map) {
      final dateMap = copy['ts'] as Map;
      if (dateMap.containsKey(r'$date')) {
        final ms = dateMap[r'$date'];
        if (ms is num) {
          copy['ts'] = DateTime.fromMillisecondsSinceEpoch(ms.toInt()).toIso8601String();
        }
      }
    }
    return copy;
  }

  void _handleMessage(String message) {
    _log('RECV: $message');
    try {
      final decoded = jsonDecode(message);
      if (decoded is! Map<String, dynamic>) return;

      final msg = decoded['msg'];
      
      if (msg == 'connected') {
        _isConnected = true;
        _log('Connected successfully!');
        if (_pendingLoginToken != null) {
          login(_pendingLoginToken!);
        }
      } else if (msg == 'ping') {
        _send({'msg': 'pong'});
      } else if (msg == 'result' && decoded['id'] == 'login-1') {
        if (decoded['error'] == null) {
          _log('Login successful! Subscribing to user presence, global messages, and active room subs...');
          subscribeToUserPresence();
          subscribeToMyMessages();
          
          // Re-subscribe to all active room message streams
          for (final roomId in _activeRoomSubs) {
            _log('Re-subscribing to room messages for $roomId');
            _send({
              'msg': 'sub',
              'id': 'sub-msg-$roomId',
              'name': 'stream-room-messages',
              'params': [roomId, false]
            });
          }
        } else {
          _log('Login failed: ${decoded['error']}');
        }
      } else if (msg == 'changed') {
        final collection = decoded['collection'];
        if (collection == 'stream-user-presence') {
          final fields = decoded['fields'];
          if (fields != null && fields['args'] != null) {
            final args = fields['args'] as List;
            if (args.isNotEmpty && args[0] is List) {
              final argData = args[0] as List;
              if (argData.length >= 2) {
                final username = argData[0] as String;
                final statusInt = argData[1] as int;
                _presenceController.add(UserPresenceEvent(username, _mapStatus(statusInt)));
              }
            }
          }
        } else if (collection == 'stream-room-messages') {
          final fields = decoded['fields'];
          if (fields != null && fields['args'] != null) {
            final args = fields['args'] as List;
            for (final arg in args) {
              if (arg is Map<String, dynamic>) {
                try {
                  final normalized = _normalizeMessageJson(arg);
                  final msgObj = RocketChatMessage.fromJson(normalized);
                  _messageController.add(msgObj);
                } on Object catch (e) {
                  _log('Error parsing room message: $e');
                }
              }
            }
          }
        }
      }
    } on Object catch (_) {
      // Ignore parsing errors for unknown/unexpected messages
    }
  }

  UserPresenceStatus _mapStatus(int status) {
    switch (status) {
      case 0: return UserPresenceStatus.offline;
      case 1: return UserPresenceStatus.online;
      case 2: return UserPresenceStatus.away;
      case 3: return UserPresenceStatus.busy;
      default: return UserPresenceStatus.unknown;
    }
  }

  void dispose() {
    _reconnectTimer?.cancel();
    unawaited(_subscription?.cancel());
    unawaited(_channel?.sink.close());
    unawaited(_presenceController.close());
    unawaited(_messageController.close());
    _isConnected = false;
  }
}
