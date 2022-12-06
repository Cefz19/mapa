import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_1/src/ui/page/home/widgets/where_are_you_going.dart';
import 'package:provider/provider.dart';

import '../controller/home_controller.dart';

class MapaView extends StatelessWidget {
  const MapaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (_, controller, gpsMessageWidget) {
        final state = controller.state;
        if (!state.gpsEnabled) {
          return gpsMessageWidget!;
        }
        final initialCameraPosition = CameraPosition(
          target: LatLng(state.initialPosition!.latitude,
              state.initialPosition!.longitude),
        );

        return Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              markers: state.markers.values.toSet(),
              polylines: state.polylines.values.toSet(),
              initialCameraPosition: initialCameraPosition,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              compassEnabled: false,
              zoomControlsEnabled: false,
            ),
            const WhereAreYouGoingButton()
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
                onPressed: () {
                  final controller = context.read<HomeController>();
                  controller.turnOnGPS();
                },
                child: const Text('Turn on GPS')),
          ],
        ),
      ),
    );
  }
}
