import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapa_1/src/data/provider/local/geolocator_wrapper.dart';
import 'package:mapa_1/src/data/provider/remote/route_api.dart';
import 'package:mapa_1/src/data/repositiries_impl/routes_repository_imp.dart';

import 'package:mapa_1/src/ui/page/home/home_controller.dart';
import 'package:mapa_1/src/ui/page/home/widgets/map_view.dart';
import 'package:provider/provider.dart';

class GoogleTransito extends StatelessWidget {
  const GoogleTransito({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) => HomeController(
        GeolocatorWrapper(),
        RoutesRepositoryImpl(
          RouteAPI(Dio()),
        ),
      ),
      child: Scaffold(
        body: Selector<HomeController, bool>(
          selector: (_, controller) => controller.state.loading,
          builder: ((context, loading, loadingWidget) {
            if (loading) {
              return loadingWidget!;
            }
            return const MapaView();
          }),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
