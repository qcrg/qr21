import "package:chirp/chirp.dart";
import "package:flutter/foundation.dart" show kReleaseMode;
import "package:flutter/material.dart";
import "package:forui/forui.dart";
import "package:path_provider/path_provider.dart";
import "package:qr21/l10n/app_localizations.dart";
import "package:qr21/providers/qr_provider.dart";
import "package:qr21/router.dart";
import "package:provider/provider.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "package:qr21/data/models/hive_adapters/hive_registrar.g.dart";

void main() async {
  Chirp.root = ChirpLogger().addConsoleWriter(
    minLogLevel: kReleaseMode ? ChirpLogLevel.warning : ChirpLogLevel.debug,
  );

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter((await getApplicationSupportDirectory()).path);
  Hive.registerAdapters();

  runApp(
    MultiProvider(
      providers: [
        Provider<Qr21RouteObserver>(create: (_) => .new()),
        ChangeNotifierProvider<QrProvider>(create: (_) => .new()),
      ],
      child: const Qr21App(),
    ),
  );
}

class Qr21App extends StatelessWidget {
  const Qr21App({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FThemes.zinc.dark.touch;

    return MaterialApp.router(
      title: "qr21",
      theme: theme.toApproximateMaterialTheme(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        FLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: make_router(context),
      builder: (context, child) {
        return FTheme(
          data: theme,
          child: FToaster(
            child: SafeArea(child: FScaffold(child: child!)),
          ),
        );
      },
    );
  }
}
