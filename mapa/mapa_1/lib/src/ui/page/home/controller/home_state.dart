import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeState {
  final bool loading, gpsEnabled;
  final Map<MarkerId, Marker> markers;
  final Map<PolygonId, Polyline> polylines;
  final LatLng? initialPosition;

  HomeState({
    required this.loading,
    required this.gpsEnabled,
    required this.markers,
    required this.polylines,
    required this.initialPosition,
  });

  static HomeState get initialState => HomeState(
        loading: true,
        gpsEnabled: false,
        markers: {},
        polylines: {},
        initialPosition: null,
      );

  HomeState copyWith({
    bool? loading,
    bool? gpsEnabled,
    Map<MarkerId, Marker>? markers,
    Map<PolygonId, Polyline>? polylines,
    LatLng? initialPosition,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      initialPosition: initialPosition ?? this.initialPosition,
    );
  }
}
