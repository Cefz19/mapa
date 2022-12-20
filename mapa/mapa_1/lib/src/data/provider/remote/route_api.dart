import 'package:dio/dio.dart';
import 'package:flexible_polyline/flexible_polyline.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_1/src/helper/const.dart';

import '../../../domain/models/route.dart';

class RouteAPI {
  final Dio _dio;

  RouteAPI(this._dio);

  Future<List<Route>?> get({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(
        'https://router.hereapi.com/v8/routes',
        queryParameters: {
          'apiKey': apikey,
          'origin': '${origin.latitude},${origin.latitude}',
          'transportMode': 'car',
          'alternatives': 3,
          'return': 'polyline,summary,instructions,actions',
        },
      );
      final routes = (response.data["routes"] as List).map(
        (e) {
          final json = e["sections"][0];
          final duration = json["summary"]['duration'] as int;
          final length = json["summary"]['length'] as int;

          final polyline = json["polyline"] as String;

          final points = FlexiblePolyline.decode(polyline)
              .map(
                (e) => LatLng(e.lat, e.lng),
              )
              .toList();

          return Route(
            duration: duration,
            length: length,
            points: points,
          );
        },
      );
      return routes.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
