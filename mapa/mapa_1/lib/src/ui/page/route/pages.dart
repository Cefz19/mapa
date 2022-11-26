import 'package:flutter/cupertino.dart';
import 'package:mapa_1/src/goolge_transito.dart';
import 'package:mapa_1/src/ui/page/request_permission/request_permission_pages.dart';
import 'package:mapa_1/src/ui/page/route/route.dart';
import 'package:mapa_1/src/ui/page/splash/splash_page.dart';

Map<String, Widget Function(BuildContext)> appRoutes() {
  return {
    Routes.SPLASH: (_) => const SplasPage(),
    Routes.PERMISSION: (_) => const RequestPermissionPage(),
    Routes.HOME: (_) => const GoogleTransito(),
  };
}
