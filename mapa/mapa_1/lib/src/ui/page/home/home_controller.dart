import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'maps_style.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};

  Set<Marker> get markers => _markers.values.toSet();

  final initialCameraPosition =
      const CameraPosition(target: LatLng(21.116667, -101.683334), zoom: 0.0);

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
  }

  void onTap(LatLng position) {
    final markerId = MarkerId(_markers.length.toString());
    final marker = Marker(
      markerId: markerId,
      position: position,
    );
    _markers[markerId] = marker;
    notifyListeners();
  }
}
