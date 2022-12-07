import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapa_1/src/data/provider/remote/search_api.dart';
import 'package:mapa_1/src/data/repositiries_impl/search_repository_impl.dart';
import 'package:mapa_1/src/domain/models/place.dart';
import 'package:mapa_1/src/ui/page/search_place/search_place_controller.dart';
import 'package:mapa_1/src/ui/page/splash/utils/distance_format.dart';
import 'package:provider/provider.dart';

class SearchPlacePage extends StatelessWidget {
  const SearchPlacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchPlaceController(
        SearchRepositoryImpl(
          SearchAPI(
            Dio(),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Builder(
            builder: (context) {
              return CupertinoTextField(
                onChanged: context.read<SearchPlaceController>().onQueryChanged,
              );
            },
          ),
        ),
        body: Consumer<SearchPlaceController>(
          builder: (_, controller, __) {
            final places = controller.places;
            if (places == null) {
              return const Center(
                child: Text('Error'),
              );
            } else if (places.isEmpty && controller.query.length >= 3) {
              return const Center(
                child: Text('Emty'),
              );
            }
            return ListView.builder(
              itemBuilder: (_, index) {
                final place = places[index];
                return ListTile(
                  leading: Text(distanceFormat(place.distance)),
                  title: Text(place.title),
                  subtitle: Text(place.address),
                );
              },
              itemCount: places.length,
            );
          },
        ),
      ),
    );
  }
}
