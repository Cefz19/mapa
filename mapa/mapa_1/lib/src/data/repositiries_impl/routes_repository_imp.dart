import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa_1/src/data/provider/remote/route_api.dart';
import 'package:mapa_1/src/domain/models/route.dart';
import 'package:mapa_1/src/domain/repositories/routes_repository.dart';

class RoutesRepositoryImpl implements RoutesRepository {
  final RouteAPI _routesAPI;

  RoutesRepositoryImpl(this._routesAPI);
  @override
  Future<List<Route>?> get({
    required LatLng origin,
    required LatLng destination,
  }) {
    return _routesAPI.get(
      origin: origin,
      destination: destination,
    );
  }
}
