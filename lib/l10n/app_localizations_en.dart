// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get serverNotFound => 'The server is not found';

  @override
  String get incorrectServer => 'The server is incorrect';

  @override
  String get botNotFound => 'QR Bot not found on the server';

  @override
  String get incorrectCredentials => 'Login or password is incorrect';

  @override
  String get unauthorized => 'You not authorized into any accounts';

  @override
  String get qrNotGenerated => 'QR-code is not genereated. Why? I don\'t know';

  @override
  String get loginFailed => 'Failed to login';

  @override
  String get login => 'Login';
}
