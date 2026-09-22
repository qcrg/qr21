import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:qr21/data/app_info.dart';
import 'package:qr21/l10n/app_localizations.dart';
import 'package:qr21/providers/app_storage_provider.dart';

class VersionNotifierWidget extends StatelessWidget {
  final Widget child;

  const VersionNotifierWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final asp = Provider.of<AppStorageProvider>(context);
    final app_info = Provider.of<AppInfo>(context, listen: false);
    final tr = AppLocalizations.of(context)!;

    final is_use_old_version = asp.lastKnownVersion > app_info.version;

    if (is_use_old_version) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showFToast(
          context: context,
          title: Text(tr.new_version),
          variant: .primary,
          description: Text(
            tr.new_app_version_released(asp.lastKnownVersion.toString()),
          ),
        );
      });
    }
    return child;
  }
}
