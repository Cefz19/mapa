import 'dart:async';

import 'package:flutter/material.dart' show ChangeNotifier, Colors;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'maps_style.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylines = {};

  Set<Marker> get markers => _markers.values.toSet();
  Set<Polyline> get polylines => _polylines.values.toSet();

  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  Position? _initialPosition;
  Position? get initialPosition => _initialPosition;

  bool _loading = true;
  bool get loading => _loading;

  late bool _gpsEnabled;
  bool get gpsEnabled => _gpsEnabled;

  StreamSubscription? _gpsSubscription, _positionSubscription;
  String _polylineId = '0';

  HomeController() {
    _init();
  }

  Future<void> _init() async {
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

  void newPolyline() {
    _polylineId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void onTap(LatLng position) async {
    final PolylineId polylineId = PolylineId(_polylineId);
    late Polyline polyline;

    if (_polylines.containsKey(polylineId)) {
      final tmp = _polylines[polylineId]!;
      polyline = tmp.copyWith(
        pointsParam: [...tmp.points, position],
      );
    } else {
      final color = Colors.primaries[_polylines.length];
      polyline = Polyline(
        polylineId: polylineId,
        points: [position],
        width: 5,
        color: color,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );
    }
    _polylines[polylineId] = polyline;
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
