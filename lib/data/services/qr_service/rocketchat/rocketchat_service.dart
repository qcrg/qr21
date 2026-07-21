import 'package:chirp/chirp.dart';
import 'package:light_result/light_result.dart';
import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/data/models/rocketchat_creds/rocketchat_creds.dart';
import 'package:qr21/data/services/qr_service/qr_internal_sevice_state.dart';
import 'package:qr21/data/services/qr_service/rocketchat/rocketchat_error.dart';
import 'package:qr21/data/services/qr_service/rocketchat/rocketchat_storage.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

final log = Chirp.root.addContext({"tag": "SERV:RC"});

// ignore: camel_case_types
class _const {
  static const String botUsername = "qr-code-generator.bot";
}

class RocketChatQrService {
  final RocketChatStorage _storage;
  final BehaviorSubject<QrInternalServiceState> _stream_ctrl = .new();
  RocketChatClient? _client;

  RocketChatQrService({RocketChatStorage? storage, this._client})
    : _storage = storage ?? RocketChatStorage() {
    log.info("Create RocketChatQrService");
    _try_init_authorized_rc_client();
  }

  ValueStream<QrInternalServiceState> get stateStream => _stream_ctrl.stream;

  Future<bool> is_authorized() async {
    return await _storage.has_creds();
  }

  Future<RocketChatError?> login({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    RocketChatError? err;

    final client = RocketChatClient(baseUrl: baseUrl);

    err = await _is_server_valid(client);
    if (err != null) {
      return err;
    }

    err = await _authorize(client, username, password, _storage);
    if (err != null) {
      return err;
    }

    _client = client;
    _stream_ctrl.add(.ready);
    return null;
  }

  Future<RocketChatError?> logout() async {
    try {
      log.info("Logout...");
      await _client?.auth.logout();

      await _storage.clear_creds();
      _stream_ctrl.add(.unready);
      log.info("Logout successfull");
      return null;
    } on RocketChatException catch (e) {
      log.error("Failed to logout", data: {"error": e.type});
      switch (e.type) {
        case .unauthorized:
          return .unauthorized;

        default:
          rethrow;
      }
    }
  }

  Future<Result<RocketChatError, QrData>> get_data() async {
    if (_client == null || !(await _storage.has_creds())) {
      log.critical("Client is uninitialized");
      return Failure(.unauthorized);
    }
    log.debug("Getting data from external...");

    return _retrive_external_data();
  }

  Future<void> _try_init_authorized_rc_client() async {
    if (!await is_authorized()) {
      log.info("Client not authorized");
      return;
    }
    final creds = (await _storage.get_creds())!;
    _client = RocketChatClient(
      baseUrl: creds.baseUrl,
      userId: creds.userId,
      authToken: creds.authToken,
    );
    log.info("Authorized as '${creds.username}' user");
    _stream_ctrl.add(.ready);
  }

  Future<void> close() async {
    await _stream_ctrl.close();
  }

  Future<RocketChatError?> _is_server_valid(RocketChatClient client) async {
    try {
      await client.misc.info();
      log.info("Server is valid", data: {"baseUrl": client.baseUrl});
      return null;
    } on RocketChatException catch (e) {
      log.error(
        "Server is invalid",
        data: {"baseUrl": client.baseUrl, "error": e.type},
      );
      switch (e.type) {
        case .notFound:
          return .incorrectServer;

        default:
          rethrow;
      }
    } catch (e) {
      log.critical(
        "Server is invalid",
        data: {"baseUrl": client.baseUrl, "exception": e},
      );
      return .serverNotFound;
    }
  }

  Future<Result<RocketChatError, QrData>> _retrive_external_data() async {
    final creds = (await _storage.get_creds())!;
    final DateTime execute_ts = _gen_now();

    try {
      await _client!.misc.commands.run(
        command: "enter",
        roomId: creds.botRoomId,
      );
      log.info("Command '/enter' executed");
    } on RocketChatException catch (e) {
      switch (e.type) {
        case .unauthorized:
          await _storage.clear_creds();
          return Failure(.unauthorized);
        default:
          rethrow;
      }
    }

    for (int i = 0; i < 10; i++) {
      log.debug("Retriving QR data attempt: $i");
      final msgs = (await _client!.dm.messages(
        roomId: creds.botRoomId,
        count: 2,
      ));
      final RocketChatMessage msg = _is_rate_limit_message(msgs.first.msg)
          ? msgs[1]
          : msgs[0];
      final msg_ts = DateTime.parse(msg.ts).toUtc();
      if (!msg_ts.isBefore(execute_ts) && !_is_generating_message(msg.msg)) {
        final QrData? data = _parse_message(msg.msg, creds.username);
        if (data != null) {
          log.info(
            "QR data is retrived",
            data: {"msg_ts": msg_ts, "expires": data.expires},
          );
          return Success(data);
        }
      }
      await Future.delayed(Duration(seconds: 1));
    }
    log.error("QR data is not retrived - attempts exhausted");
    return Failure(.qrNotGenerated);
  }
}

Future<RocketChatError?> _authorize(
  RocketChatClient client,
  String username,
  String password,
  RocketChatStorage storage,
) async {
  try {
    log.info("RC:API Login '$username' user...");
    await client.auth.login(username: username, password: password);
    log.info("RC:API User '$username' is authorized");
  } on RocketChatException catch (e) {
    log.error("RC:API Failed to login", data: {"error": e.type});
    switch (e.type) {
      case RocketChatErrorType.notFound:
        return .incorrectServer;

      case RocketChatErrorType.unauthorized:
        return .incorrectCredentials;

      default:
        rethrow;
    }
  }

  final room_id = await _get_bot_room_id(client);
  if (room_id.isFailure) {
    log.error(
      "Bot not found",
      data: {"baseUrl": client.baseUrl, "error": room_id.getFailureOrNull()},
    );
    return room_id.getFailureOrNull()!;
  }

  await storage.set_creds(
    RocketChatCreds(
      baseUrl: client.baseUrl,
      username: username,
      authToken: client.authToken,
      userId: client.userId,
      botRoomId: room_id.getOrNull()!,
    ),
  );
  log.info("Authorization is successfull for '$username'");
  return null;
}

Future<Result<RocketChatError, String>> _get_bot_room_id(
  RocketChatClient client,
) async {
  try {
    final room = await client.dm.create(username: _const.botUsername);
    log.info("Bot is found");
    return Success(room.id);
  } on RocketChatException catch (e) {
    if (e.type == .notFound) {
      log.error("Bot not found");
      return Failure(.botNotFound);
    }
    rethrow;
  }
}

final _date_pattern = RegExp(r'[0-3][0-9]\.[0-1][0-9]\.[0-9]{4}');
final _qr_pattern = RegExp(r'\[QR code\]\((.+)\)');
final _rate_limit_patter = RegExp(
  r'Please wait [0-9]{1,3} seconds before calling the command again\.',
);
final _generate_pattern = RegExp(r'Generating QR code...');

bool _is_rate_limit_message(String msg) {
  return _rate_limit_patter.hasMatch(msg);
}

bool _is_generating_message(String msg) {
  return _generate_pattern.hasMatch(msg);
}

QrData? _parse_message(String msg, String username) {
  final date_match = _date_pattern.firstMatch(msg);
  final qr_match = _qr_pattern.firstMatch(msg);

  if (date_match == null || qr_match == null || qr_match.group(1) == null) {
    return null;
  }

  final ds = date_match[0]!.split('.');
  final expires = DateTime(
    int.parse(ds[2]),
    int.parse(ds[1]),
    int.parse(ds[0]),
  ).toUtc();
  return QrData(src: qr_match.group(1)!, username: username, expires: expires);
}

DateTime _gen_now() {
  final now = DateTime.now().toUtc();
  // return now.subtract(Duration(seconds: 20));
  return DateTime(now.year, now.month, now.day);
}
