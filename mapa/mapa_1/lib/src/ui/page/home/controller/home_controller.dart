import 'dart:async';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_1/src/helper/current_position.dart';
import 'package:mapa_1/src/ui/page/home/controller/home_state.dart';
import '../../../../domain/models/place.dart';
import '../maps_style.dart';

class HomeController extends ChangeNotifier {
  HomeState _state = HomeState.initialState;
  HomeState get state => _state;

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
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    await _positionSubscription?.cancel();
    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (position) async {
        if (!initialized) {
          _setInitialPosition(position);
          initialized = true;
          notifyListeners();
        }
        CurrentPosition.i.setValue(
          LatLng(
            position.latitude,
            position.longitude,
          ),
        );
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
    if (state.gpsEnabled && state.initialPosition == null) {
      _state = state.copyWith(
        initialPosition: LatLng(
          position.latitude,
          position.longitude,
        ),
        loading: false,
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
    _mapController = controller;
  }

  void setOriginAndDestination(Place origin, Place destination) {
    final copy = {
      ..._state.markers
    }; //final copy = Map<MarkerId, Marker>.from(_state.markers);

    const originId = MarkerId('origin');
    const destinationId = MarkerId('destination');

    final originMarker = Marker(
        markerId: originId,
        position: origin.position,
        infoWindow: InfoWindow(
          title: origin.title,
        ));

    final destinationMarker = Marker(
      markerId: destinationId,
      position: destination.position,
      infoWindow: InfoWindow(
        title: destination.title,
      ),
    );
    copy[originId] = originMarker;
    copy[destinationId] = destinationMarker;

    _state = _state.copyWith(
      origin: origin,
      destination: destination,
    );
    notifyListeners();
  }

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();

    super.dispose();
  }
}
