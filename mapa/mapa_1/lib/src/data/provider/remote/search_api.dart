import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/models/place.dart';

class SearchAPI {
  final Dio _dio;
  SearchAPI(this._dio);
  Future<List<Place>?> search(String query, LatLng at) async {
    try {
      final response = await _dio.get(
        '/',
        queryParameters: {
          "apiKey": '/',
          "q": query,
          "at": '/',
          "in": '/',
          "type": '/',
        },
      );
      return (response.data['items'] as List)
          .map(
            (e) => Place.fromJson(e),
          )
          .toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
