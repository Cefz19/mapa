import 'package:mapa_1/src/data/provider/remote/search_api.dart';
import 'package:mapa_1/src/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa_1/src/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchAPI _searchAPI;

  SearchRepositoryImpl(this._searchAPI);

  @override
  Future<List<Place>?> search(String query, LatLng at) {
    return _searchAPI.search(query, at);
  }
}
