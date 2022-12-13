import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mapa_1/src/data/provider/remote/search_api.dart';
import 'package:mapa_1/src/data/repositiries_impl/search_repository_impl.dart';
import 'package:mapa_1/src/ui/page/search_place/search_place_controller.dart';
import 'package:mapa_1/src/ui/page/search_place/widgets/search_input.dart';
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
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black87,
          ),
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Builder(builder: (context) {
                  final controller = Provider.of<SearchPlaceController>(context,
                      listen: false);
                  return Column(
                    children: [
                      SearchInput(
                        controller: controller.originController,
                        focusNode: controller.originFocusNode,
                        placeholder: 'origin',
                        onChanged: controller.onQueryChanged,
                      ),
                      SearchInput(
                        controller: controller.destinationController,
                        focusNode: controller.destinationFocusNode,
                        placeholder: 'destination',
                        onChanged: controller.onQueryChanged,
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 10.0),
                Expanded(
                  child: Consumer<SearchPlaceController>(
                    builder: (_, controller, __) {
                      final places = controller.places;
                      if (places == null) {
                        return const Center(
                          child: Text('Error'),
                        );
                      } else if (places.isEmpty &&
                          controller.query.length >= 3) {
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
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                controller.pickPlace(place);
                              });
                        },
                        itemCount: places.length,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
