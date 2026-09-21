import 'package:chirp/chirp.dart';
import 'package:light_result/light_result.dart';
import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/data/models/rocketchat_creds/rocketchat_creds.dart';
import 'package:qr21/data/services/qr_service/qr_internal_sevice_state.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/extract_context.dart';
import 'package:qr21/data/services/qr_service/rocketchat/rocketchat_error.dart';
import 'package:qr21/data/services/qr_service/rocketchat/qr_extractor/qr_extractor.dart';
import 'package:qr21/data/services/qr_service/rocketchat/rocketchat_storage.dart';
import 'package:rocketchat_sdk/rocketchat_sdk.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

final _log = Chirp.root.addContext({"tag": "SERV:RC"});

// ignore: camel_case_types
class _const {
  static const String botUsername = "qr-code-generator.bot";
  static const int max_attempts_for_gen_qr = 30;
}

class RocketChatQrService {
  final RocketChatStorage _storage;
  final BehaviorSubject<QrInternalServiceState> _stream_ctrl = .new();
  RocketChatClient? _client;

  RocketChatQrService({RocketChatStorage? storage, this._client})
    : _storage = storage ?? RocketChatStorage() {
    _log.info("Create RocketChatQrService");
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
      _log.info("Logout...");
      await _client?.auth.logout();

      await _storage.clear_creds();
      _stream_ctrl.add(.unready);
      _log.info("Logout successfull");
      return null;
    } on RocketChatException catch (e) {
      _log.error("Failed to logout", data: {"error": e.type});
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
      _log.critical("Client is uninitialized");
      return Failure(.unauthorized);
    }
    _log.debug("Getting data from external...");

    return _retrive_external_data();
  }

  Future<void> close() async {
    await _stream_ctrl.close();
  }

  Future<void> _try_init_authorized_rc_client() async {
    if (!await is_authorized()) {
      _log.info("Client not authorized");
      return;
    }
    final creds = (await _storage.get_creds())!;
    _client = RocketChatClient(
      baseUrl: creds.baseUrl,
      userId: creds.userId,
      authToken: creds.authToken,
    );
    _log.info("Authorized as '${creds.username}' user");
    _stream_ctrl.add(.ready);
  }

  Future<RocketChatError?> _is_server_valid(RocketChatClient client) async {
    try {
      await client.misc.info();
      _log.info("Server is valid", data: {"baseUrl": client.baseUrl});
      return null;
    } on RocketChatException catch (e) {
      _log.error(
        "Server is invalid",
        data: {"baseUrl": client.baseUrl, "error": e.type},
      );
      switch (e.type) {
        case .notFound:
          return .incorrectServer;

        case .forbidden:
          return .wtfMoment;

        default:
          rethrow;
      }
    } catch (e) {
      _log.critical(
        "Server is invalid",
        data: {"baseUrl": client.baseUrl, "exception": e},
      );
      return .serverNotFound;
    }
  }

  Future<Result<RocketChatError, QrData>> _retrive_external_data() async {
    final creds = (await _storage.get_creds())!;
    final DateTime execute_ts = _gen_now();

    final bot_room_id_res = await _get_bot_room_id(_client!);
    if (bot_room_id_res.isFailure) {
      return Failure(bot_room_id_res.getFailureOrNull()!);
    }
    final bot_room_id = bot_room_id_res.getOrNull()!;

    await Future.delayed(Duration(milliseconds: 200));

    final QrData? qr_data = await _extract_qr_from_messages(
      client: _client!,
      bot_room_id: bot_room_id,
      execute_ts: execute_ts,
      username: creds.username,
    );
    if (qr_data != null) {
      return Success(qr_data);
    }

    final qr_gen_err = await _gen_qr(_client!, bot_room_id);
    if (qr_gen_err != null) {
      return Failure(.qrNotGenerated);
    }

    for (int i = 0; i < 10; i++) {
      _log.debug("Retriving QR data attempt: $i");
      final QrData? qr_data = await _extract_qr_from_messages(
        client: _client!,
        bot_room_id: bot_room_id,
        execute_ts: execute_ts,
        username: creds.username,
      );
      if (qr_data != null) {
        return Success(qr_data);
      }
      await Future.delayed(Duration(seconds: 1));
    }
    _log.error("QR data is not retrived - attempts exhausted");
    return Failure(.qrNotGenerated);
  }
}

Future<RocketChatError?> _gen_qr(
  RocketChatClient client,
  String bot_room_id,
) async {
  for (int attempt = 0; attempt < _const.max_attempts_for_gen_qr; attempt++) {
    try {
      _log.info("Generating QR-code... Attempt: '$attempt']");
      await client.misc.commands.run(
        command: "enter",
        roomId: bot_room_id,
      );
      _log.info("QR-code is generated");

      return null;
    } on RocketChatException catch (e) {
      switch (e.type) {
        case .unauthorized:
          return .unauthorized;

        case .badRequest:
          await Future.delayed(Duration(milliseconds: 100));
          continue;

        default:
          rethrow;
      }
    }
  }
  return .wtfMoment;
}

Future<RocketChatError?> _authorize(
  RocketChatClient client,
  String username,
  String password,
  RocketChatStorage storage,
) async {
  try {
    _log.info("RC:API Login '$username' user...");
    await client.auth.login(username: username, password: password);
    _log.info("RC:API User '$username' is authorized");
  } on RocketChatException catch (e) {
    _log.error("RC:API Failed to login", data: {"error": e.type});
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
    _log.error(
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
    ),
  );
  _log.info("Authorization is successfull for '$username'");
  return null;
}

Future<Result<RocketChatError, String>> _get_bot_room_id(
  RocketChatClient client,
) async {
  try {
    final room = await client.dm.create(username: _const.botUsername);
    _log.info("Bot is found '${room.id}'");
    return Success(room.id);
  } on RocketChatException catch (e) {
    if (e.type == .notFound) {
      _log.error("Bot not found");
      return Failure(.botNotFound);
    }
    rethrow;
  }
}

DateTime _gen_now() {
  final now = DateTime.now().toUtc();
  return DateTime.utc(now.year, now.month, now.day);
}

enum _ParseMessageError {
  qrNotFound,
  expired,
}

Future<Result<_ParseMessageError, QrData>> _parse_messages({
  required List<RocketChatMessage> messages,
  required DateTime execute_ts,
  required String username,
  required RocketChatClient client,
}) async {
  QrExtractor qr_extractor = .new();
  final QrData? qr = await qr_extractor.extract(
    messages,
    ExtractContext(attachment_getter: .new(client: client)),
  );
  if (qr == null) {
    return Failure(.qrNotFound);
  }
  if (qr.isExpired()) {
    return Failure(.expired);
  }
  if (qr.username.isNotEmpty) {
    _log.wtf("The Username for extracted qr is filled");
  }
  return Success(qr.copyWith(username: username));
}

Future<QrData?> _extract_qr_from_messages({
  required RocketChatClient client,
  required String bot_room_id,
  required DateTime execute_ts,
  required String username,
}) async {
  final msgs = (await client.dm.messages(
    roomId: bot_room_id,
    count: 10,
  ));
  final result = await _parse_messages(
    messages: msgs,
    execute_ts: execute_ts,
    username: username,
    client: client,
  );
  switch (result) {
    case Success(value: final qr):
      return qr;
    case Failure(value: final _):
      return null;
  }
}
