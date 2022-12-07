import 'package:mapa_1/src/data/provider/remote/search_api.dart';
import 'package:mapa_1/src/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa_1/src/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchAPI _searchAPI;

  SearchRepositoryImpl(this._searchAPI);

  @override
  void search(String query, LatLng at) {
    _searchAPI.search(query, at);
  }

  @override
  void cancel() {
    _searchAPI.cancel();
  }

  @override
  void dispose() {
    _searchAPI.dispose();
  }

  @override
  Stream<List<Place>?> get onResults => _searchAPI.onResults;
}
