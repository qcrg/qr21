// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get language => 'Русский';

  @override
  String get serverNotFound => 'Сервер не найден';

  @override
  String get incorrectServer => 'Сервер не является сервером RocketChat';

  @override
  String get botNotFound => 'QR-бот не был найден на сервере';

  @override
  String get incorrectCredentials => 'Логин или пароль не верны';

  @override
  String get unauthorized => 'Отсутствует авторизация к какому-либо серверу';

  @override
  String get qrNotGenerated => 'QR-код не был сгенерирован. Почему? Понятия не имею';

  @override
  String get loginFailed => 'Ошибка авторизации';

  @override
  String get login => 'Авторизоваться';
}
