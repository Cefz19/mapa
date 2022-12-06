import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import '../models/place.dart';

abstract class SearchRepository {
  Future<List<Place>?> search(String query, LatLng at);
}
