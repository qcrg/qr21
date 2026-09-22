import 'package:flutter/foundation.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:qr21/data/app_storage.dart';

class AppStorageProvider extends ChangeNotifier {
  final AppStorage _storage;
  Version _version;
  String? _last_release_url;
  AppStorageProvider({required this._storage})
    : _version = _storage.getLastKnownVersion(),
      _last_release_url = _storage.getLastReleaseUrl();

  static Future<AppStorageProvider> make({AppStorage? storage}) async {
    storage ??= await AppStorage.make();
    return AppStorageProvider(storage: storage);
  }

  Version get lastKnownVersion => _version;
  set lastKnownVersion(Version new_ver) {
    if (_version == new_ver) {
      return;
    }
    _version = new_ver;
    _storage.setLastKnownAppVersion(new_ver);
    notifyListeners();
  }

  String? get lastReleaseUrl => _last_release_url;
  set lastReleaseUrl(String url) {
    if (_last_release_url == url) {
      return;
    }
    _last_release_url = url;
    _storage.setLastReleaseUrl(url);
    notifyListeners();
  }
}
