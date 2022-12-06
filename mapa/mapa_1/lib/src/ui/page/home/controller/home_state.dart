import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeState {
  final bool loading;
  final bool gpsEnabled;
  final Map<MarkerId, Marker> markers;
  final Map<PolygonId, Polyline> polylines;

  HomeState({
    required this.loading,
    required this.gpsEnabled,
    required this.markers,
    required this.polylines,
  });

  static HomeState get initialState => HomeState(
        loading: true,
        gpsEnabled: false,
        markers: {},
        polylines: {},
      );

  HomeState copyWith({
    bool? loading,
    bool? gpsEnabled,
    Map<MarkerId, Marker>? markers,
    Map<PolygonId, Polyline>? polylines,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
    );
  }
}
