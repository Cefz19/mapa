import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import '../models/route.dart';

abstract class RoutesRepository {
  Future<List<Route>?> get({
    required LatLng origin,
    required LatLng destination,
  });
}
