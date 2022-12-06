import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapa_1/src/data/provider/remote/search_api.dart';
import 'package:mapa_1/src/data/repositiries_impl/search_repository_impl.dart';
import 'package:mapa_1/src/ui/page/search_place/search_place_controller.dart';
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
      ),
    );
  }
}
