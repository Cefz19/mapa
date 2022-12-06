import 'dart:async';

import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:mapa_1/src/domain/repositories/search_repository.dart';
import 'package:mapa_1/src/helper/current_position.dart';

class SearchPlaceController extends ChangeNotifier {
  final SearchRepository _searchRepository;
  String _query = '';

  SearchPlaceController(this._searchRepository);
  String get query => _query;

  Timer? _debouncer;

  void onQueryChanged(String text) {
    _query = text;
    _debouncer = Timer(const Duration(milliseconds: 400), () async {
      if (_query.length >= 3) {
        // ignore: avoid_print
        print('Call to API');
        final currentPosition = CurrentPosition.i.value;
        if (currentPosition != null) {
          final results =
              await _searchRepository.search(query, currentPosition);
          // ignore: avoid_print
          print('results ${results?.length}');
        }
      } else {
        // ignore: avoid_print
        print('Cancel to API');
      }
    });
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }
}
