import 'dart:async';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_1/src/data/provider/local/geolocator_wrapper.dart';
import 'package:mapa_1/src/helper/current_position.dart';
import 'package:mapa_1/src/ui/page/home/controller/home_state.dart';
import 'package:mapa_1/src/ui/page/splash/utils/fit_map.dart';
import '../../../../domain/models/place.dart';
import '../maps_style.dart';

class HomeController extends ChangeNotifier {
  HomeState _state = HomeState.initialState;
  HomeState get state => _state;

  StreamSubscription? _gpsSubscription, _positionSubscription;

  GoogleMapController? _mapController;

  final GeolocatorWrapper _geolocator;

  HomeController(this._geolocator) {
    _init();
  }

  Future<void> _init() async {
    final gpsEnabled = await Geolocator.isLocationServiceEnabled();
    _state = state.copyWith(gpsEnabled: gpsEnabled);

    _gpsSubscription = _geolocator.onServiceEnabled.listen(
      (enabled) {
        _state = state.copyWith(gpsEnabled: enabled);
        notifyListeners();
      },
    );

    _initLocationUpDates();
  }

  Future<void> _initLocationUpDates() async {
    bool initialized = false;

    _positionSubscription = _geolocator.onLocationUpdates.listen(
      (position) {
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

  void setOriginAndDestination(Place origin, Place destination) async {
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
    await _mapController?.animateCamera(
      fitMap(
        origin.position,
        destination.position,
        padding: 100,
      ),
    );
    notifyListeners();
  }

  Future<void> turnOnGPS() => _geolocator.openLocationSettings();

  Future<void> zoomIn() => _zoom(true);

  Future<void> zoomOut() => _zoom(false);

  Future<void> _zoom(bool zoomIn) async {
    if (_mapController != null) {
      double zoom = await _mapController!.getZoomLevel();
      if (!zoomIn) {
        if (zoom - 1 <= 0) {
          return;
        }
      }

      zoom = zoomIn ? zoom + 1 : zoom - 1;

      final bounds = await _mapController!.getVisibleRegion();
      final northeast = bounds.northeast;
      final southwest = bounds.southwest;
      final center = LatLng((northeast.latitude + southwest.latitude) / 2,
          (northeast.longitude + southwest.longitude) / 2);
      final cameraUpdate = CameraUpdate.newLatLngZoom(center, zoom);
      await _mapController!.animateCamera(cameraUpdate);
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();

    super.dispose();
  }
}
