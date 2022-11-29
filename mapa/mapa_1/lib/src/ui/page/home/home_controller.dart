import 'dart:async';

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_1/src/helper/image_to_bite.dart';
import 'maps_style.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};

  Set<Marker> get markers => _markers.values.toSet();

  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  Position? _initialPosition;
  CameraPosition get initialCameraPosition => CameraPosition(
        target: LatLng(_initialPosition!.latitude, _initialPosition!.longitude),
      );

  final _acumuladorIcon = Completer<BitmapDescriptor>();

  bool _loading = true;
  bool get loading => _loading;

  late bool _gpsEnabled;
  bool get gpsEnabled => _gpsEnabled;

  StreamSubscription? _gpsSubscription, _positionSubscription;

  HomeController() {
    _init();
  }

  Future<void> _init() async {
    final value = await imageToBytes(
      'https://i2.wp.com/www3.gobiernodecanarias.org/medusa/ecoblog/crodalf/files/2021/10/calabaza.jpg?fit=450%2C413&ssl=1',
      width: 60,
      fromNetwork: true,
    );
    final bitmap = BitmapDescriptor.fromBytes(value);
    _acumuladorIcon.complete(bitmap);

    _gpsEnabled = await Geolocator.isLocationServiceEnabled();

    _loading = false;
    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) async {
        _gpsEnabled = status == ServiceStatus.enabled;
        if (_gpsEnabled) {
          _initLocationUpDates();
        }
      },
    );
    _initLocationUpDates();
  }

  Future<void> _initLocationUpDates() async {
    bool initialized = false;
    await _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream().listen(
      (position) {
        // ignore: avoid_print
        print(('object'));
        if (!initialized) {
          _setInitialPosition(position);
          initialized = true;
          notifyListeners();
        }
      },
      onError: (e) {
        // ignore: avoid_print
        print("on Error ${e.runtimeType}");
        if (e is LocationServiceDisabledException) {
          _gpsEnabled = false;
          notifyListeners();
        }
      },
    );
  }

  void _setInitialPosition(Position position) {
    if (_gpsEnabled && _initialPosition == null) {
      // _initialPosition = await Geolocator.getCurrentPosition();
      _initialPosition = position;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
  }

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

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
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();
    _markersController.close();
    super.dispose();
  }
}
