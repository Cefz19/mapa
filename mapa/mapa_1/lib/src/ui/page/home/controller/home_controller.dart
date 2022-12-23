import 'dart:async';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_1/src/data/provider/local/geolocator_wrapper.dart';
import 'package:mapa_1/src/domain/repositories/routes_repository.dart';
import 'package:mapa_1/src/helper/current_position.dart';
import 'package:mapa_1/src/ui/page/home/controller/home_state.dart';
import 'package:mapa_1/src/ui/page/home/controller/utils/set_route.dart';
import 'package:mapa_1/src/ui/page/home/controller/utils/set_zoom.dart';
import 'package:mapa_1/src/ui/page/home/widgets/circle_marker.dart';
import 'package:mapa_1/src/ui/page/splash/utils/fit_map.dart';
import '../../../../domain/models/place.dart';
import '../maps_style.dart';

class HomeController extends ChangeNotifier {
  HomeState _state = HomeState.initialState;
  HomeState get state => _state;

  StreamSubscription? _gpsSubscription, _positionSubscription;

  GoogleMapController? _mapController;

  final GeolocatorWrapper _geolocator;
  final RoutesRepository _routesRepository;

  BitmapDescriptor? _dotMarker;

  HomeController(
    this._geolocator,
    this._routesRepository,
  ) {
    _init();
  }

  Future<void> _init() async {
    final gpsEnabled = await _geolocator.isLocationServiceEnabled;
    _state = state.copyWith(gpsEnabled: gpsEnabled);

    _gpsSubscription = _geolocator.onServiceEnabled.listen(
      (enabled) {
        _state = state.copyWith(gpsEnabled: enabled);
        notifyListeners();
      },
    );
    _initLocationUpDates();
    _dotMarker = await getDotMarker();
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
    final routes = await _routesRepository.get(
      origin: origin.position,
      destination: destination.position,
    );
    if (routes != null && routes.isNotEmpty) {
      _state = await setRouteAndMarkers(
        state: state,
        routes: routes,
        origin: origin,
        destination: destination,
        dot: _dotMarker!,
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
  }

  Future<void> turnOnGPS() => _geolocator.openLocationSettings();

  Future<void> zoomIn() async {
    if (_mapController != null) {
      await setZoom(_mapController!, true);
    }
  }

  Future<void> zoomOut() async {
    if (_mapController != null) {
      await setZoom(_mapController!, false);
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();

    super.dispose();
  }
}
