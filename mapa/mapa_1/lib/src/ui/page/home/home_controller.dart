import 'dart:async';

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_1/src/helper/image_to_bite.dart';

import 'maps_style.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};

  Set<Marker> get markers => _markers.values.toSet();

  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  final initialCameraPosition = const CameraPosition(
    target: LatLng(21.116667, -101.683334),
    zoom: 15,
  );

  final _acumuladorIcon = Completer<BitmapDescriptor>();

  HomeController() {
    imageToBytes(
      'https://i2.wp.com/www3.gobiernodecanarias.org/medusa/ecoblog/crodalf/files/2021/10/calabaza.jpg?fit=450%2C413&ssl=1',
      width: 60,
      fromNetwork: true,
    ).then(
      (value) {
        final bitMap = BitmapDescriptor.fromBytes(value);
        _acumuladorIcon.complete(bitMap);
      },
    );
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
  }

  void onTap(LatLng position) async {
    final id = _markers.length.toString();
    final markerId = MarkerId(id);

    final icon = await _acumuladorIcon.future;

    final marker = Marker(
        markerId: markerId,
        position: position,
        draggable: true,
        //anchor: const Offset(0.5, 1),
        icon: icon,
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
