import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_1/src/ui/page/home/home_controller.dart';
import 'package:provider/provider.dart';

class GoogleTransito extends StatelessWidget {
  const GoogleTransito({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) {
        final controller = HomeController();
        controller.onMarkerTap.listen((String id) {
          // ignore: avoid_print
          print('got to $id');
        });
        return controller;
      },
      child: Scaffold(
        body: Selector<HomeController, bool>(
          selector: (_, controller) => controller.loading,
          builder: ((context, loading, loadingWidget) {
            if (loading) {
              return loadingWidget!;
            }
            return Consumer<HomeController>(
              builder: (_, controller, gpsMessageWidget) {
                if (controller.gpsEnabled) {
                  return gpsMessageWidget!;
                }
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        markers: controller.markers,
                        mapType: MapType.normal,
                        initialCameraPosition: controller.initialCameraPosition,
                        onMapCreated: controller.onMapCreated,
                        onTap: controller.onTap,
                      ),
                    )
                  ],
                );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        'To use our app we need the acess to your location,\n so you must the GPS',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Turn on GPS')),
                  ],
                ),
              ),
            );
          }),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
