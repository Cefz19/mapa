import 'dart:async';

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'maps_style.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};

  Set<Marker> get markers => _markers.values.toSet();

  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  final initialCameraPosition =
      const CameraPosition(target: LatLng(21.116667, -101.683334), zoom: 0.0);

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
  }

  void onTap(LatLng position) {
    final id = _markers.length.toString();
    final markerId = MarkerId(id);
    final marker = Marker(
        markerId: markerId,
        position: position,
        draggable: true,
        //anchor: const Offset(0.5, 1),
        icon: BitmapDescriptor.defaultMarkerWithHue(200),
        onTap: () {
          _markersController.sink.add(id);
        },
        onDragEnd: (newPosition) {
          // ignore: avoid_print
          print('new position $newPosition');
        });
    _markers[markerId] = marker;
    notifyListeners();
  }

  @override
  void dispose() {
    _markersController.close();
    super.dispose();
  }
}
