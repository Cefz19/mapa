import 'package:flutter/material.dart';

import 'package:mapa_1/src/ui/page/home/home_controller.dart';
import 'package:mapa_1/src/ui/page/home/widgets/map_view.dart';
import 'package:provider/provider.dart';

class GoogleTransito extends StatelessWidget {
  const GoogleTransito({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) {
        final controller = HomeController();
        return controller;
      },
      child: Scaffold(
        body: Selector<HomeController, bool>(
          selector: (_, controller) => controller.loading,
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
