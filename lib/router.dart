import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr21/providers/qr_provider.dart';
import 'package:qr21/screens/login/login.dart';
import 'package:qr21/screens/info/info.dart';

class Routes {
  static const login = "/login";
  static const info = "/info";
  static const settings = "/settings";
}

GoRouter make_router(BuildContext context) {
  final qrprov = Provider.of<QrProvider>(context, listen: false);
  final route_observer = Provider.of<Qr21RouteObserver>(context, listen: false);
  return GoRouter(
    initialLocation: Routes.info,
    observers: [route_observer],
    redirect: _redirect,
    refreshListenable: qrprov,
    routes: [
      GoRoute(path: Routes.info, builder: (context, state) => Info()),
      GoRoute(path: Routes.login, builder: (context, state) => Login()),
    ],
  );
}

typedef Qr21RouteObserver = RouteObserver<PageRoute>;

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final qrprov = Provider.of<QrProvider>(context, listen: false);
  final is_authorized = await qrprov.service.is_authorized();
  final is_login_page = state.matchedLocation == Routes.login;

  if (is_authorized && is_login_page) {
    return Routes.info;
  }

  if (!is_authorized && !is_login_page) {
    return Routes.login;
  }

  return null;
}
