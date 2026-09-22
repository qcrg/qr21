import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class AppInfo {
  final PackageInfo _package_info;
  const AppInfo({required this._package_info});

  static Future<AppInfo> make({PackageInfo? package_info}) async {
    package_info ??= await PackageInfo.fromPlatform();
    return AppInfo(package_info: package_info);
  }

  Version get version => Version.parse(_package_info.version);
}
