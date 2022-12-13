import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../domain/models/place.dart';

class HomeState {
  final bool loading, gpsEnabled;
  final Map<MarkerId, Marker> markers;
  final Map<PolygonId, Polyline> polylines;
  final LatLng? initialPosition;
  final Place? origin, destination;

  HomeState({
    required this.loading,
    required this.gpsEnabled,
    required this.markers,
    required this.polylines,
    required this.initialPosition,
    required this.origin,
    required this.destination,
  });

  static HomeState get initialState => HomeState(
        loading: true,
        gpsEnabled: false,
        markers: {},
        polylines: {},
        initialPosition: null,
        origin: null,
        destination: null,
      );

  HomeState copyWith({
    bool? loading,
    bool? gpsEnabled,
    Map<MarkerId, Marker>? markers,
    Map<PolygonId, Polyline>? polylines,
    LatLng? initialPosition,
    Place? origin,
    Place? destination,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      initialPosition: initialPosition ?? this.initialPosition,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
    );
  }
}
