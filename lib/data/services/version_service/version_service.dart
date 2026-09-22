import 'package:chirp/chirp.dart';
import 'package:github/github.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:qr21/providers/app_storage_provider.dart';

final _log = Chirp.root.addContext({"tag": "VERSION_SERVICE"});

class VersionService {
  final AppStorageProvider _asp;
  VersionService({required AppStorageProvider app_storage_provider})
    : _asp = app_storage_provider {
    _run();
  }

  Future<void> _run() async {
    final client = GitHub();
    final rel = await client.repositories.getLatestRelease(
      RepositorySlug("qcrg", "qr21"),
    );
    if (rel.tagName == null) {
      _log_incorrect_version(null);
      return;
    }
    try {
      _asp.lastKnownVersion = Version.parse(rel.tagName!.replaceFirst("v", ""));
      _asp.lastReleaseUrl = rel.htmlUrl!;
    } on FormatException catch (_) {
      _log_incorrect_version(rel.tagName);
    }
  }
}

void _log_incorrect_version(String? version) {
  if (version == null) {
    _log.error("Version is not defined (github tagName)");
  } else {
    _log.error("Version is incorrect '$version'");
  }
}
