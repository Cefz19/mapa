import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mapa_1/src/data/provider/remote/search_api.dart';
import 'package:mapa_1/src/data/repositiries_impl/search_repository_impl.dart';
import 'package:mapa_1/src/ui/page/search_place/search_place_controller.dart';
import 'package:mapa_1/src/ui/page/search_place/widgets/search_app_bar.dart';

import 'package:mapa_1/src/ui/page/search_place/widgets/search_results.dart';

import 'package:provider/provider.dart';

import '../../../domain/models/place.dart';
import 'widgets/searchs_inputs.dart';

class SearchResponse {
  final Place origin, destination;

  SearchResponse(
    this.origin,
    this.destination,
  );
}

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
        appBar: const SearchAppBar(),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: const [
                SearchInputs(),
                SizedBox(height: 10.0),
                Expanded(
                  child: SearchResults(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
