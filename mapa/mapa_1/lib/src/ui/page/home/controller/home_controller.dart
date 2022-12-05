import 'dart:async';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_1/src/ui/page/home/controller/home_state.dart';
import '../maps_style.dart';

class HomeController extends ChangeNotifier {
  HomeState _state = HomeState.initialState;
  HomeState get state => _state;

  Position? _initialPosition;
  Position? get initialPosition => _initialPosition;

  StreamSubscription? _gpsSubscription, _positionSubscription;
  GoogleMapController? _mapController;

  HomeController() {
    _init();
  }

  Future<void> _init() async {
    final gpsEnabled = await Geolocator.isLocationServiceEnabled();
    _state = state.copyWith(gpsEnabled: gpsEnabled);

    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) async {
        final gpsEnabled = status == ServiceStatus.enabled;
        if (gpsEnabled) {
          _state = state.copyWith(gpsEnabled: gpsEnabled);
          _initLocationUpDates();
        }
      },
    );
    _initLocationUpDates();
  }

  Future<void> _initLocationUpDates() async {
    bool initialized = false;
    await _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ).listen(
      (position) async {
        if (!initialized) {
          _setInitialPosition(position);
          initialized = true;
          notifyListeners();
        }
      },
      onError: (e) {
        if (e is LocationServiceDisabledException) {
          _state = state.copyWith(gpsEnabled: false);
          notifyListeners();
        }
      },
    );
  }

  void _setInitialPosition(Position position) {
    if (state.gpsEnabled && _initialPosition == null) {
      // _initialPosition = await Geolocator.getCurrentPosition();
      _initialPosition = position;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
    _mapController = controller;
  }

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();

    super.dispose();
  }
}
