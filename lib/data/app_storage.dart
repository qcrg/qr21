import 'package:hive_ce/hive_ce.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:qr21/data/app_info.dart';

enum _Keys {
  lastKnownAppVersion,
  lastReleaseUrl,
}

// ignore: camel_case_types
class _const {
  static const String box_name = "app_storage";
}

class AppStorage {
  final Box _box;
  final AppInfo _app_info;

  AppStorage({required this._box, required this._app_info});

  static Future<AppStorage> make({Box? box, AppInfo? app_info}) async {
    box ??= await Hive.openBox(_const.box_name);
    if (app_info == null) {
      final pinfo = await PackageInfo.fromPlatform();
      app_info = AppInfo(package_info: pinfo);
    }
    return AppStorage(box: box, app_info: app_info);
  }

  Version getLastKnownVersion() {
    final Version curv = _app_info.version;
    if (!_box.containsKey(_Keys.lastKnownAppVersion.name)) {
      return curv;
    }
    final lastv = Version.parse(_box.get(_Keys.lastKnownAppVersion.name));
    return lastv < curv ? curv : lastv;
  }

  Future<void> setLastKnownAppVersion(Version ver) async {
    await _box.put(_Keys.lastKnownAppVersion.name, ver.toString());
  }

  String? getLastReleaseUrl() {
    return _box.get(_Keys.lastReleaseUrl.name);
  }

  Future<void> setLastReleaseUrl(String url) async {
    await _box.put(_Keys.lastReleaseUrl.name, url);
  }
}
