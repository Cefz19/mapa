import 'dart:async';

import 'package:flutter/cupertino.dart'
    show ChangeNotifier, FocusNode, TextEditingController;
import 'package:mapa_1/src/domain/models/place.dart';
import 'package:mapa_1/src/domain/repositories/search_repository.dart';
import 'package:mapa_1/src/helper/current_position.dart';

class SearchPlaceController extends ChangeNotifier {
  final SearchRepository _searchRepository;
  String _query = '';
  String get query => _query;
  late StreamSubscription _subscription;

  List<Place>? _places = [];
  List<Place>? get places => _places;

  Place? _origin, _destination;

  Place? get origin => _origin;
  Place? get destination => _destination;

  final originFocusNode = FocusNode();
  final destinationFocusNode = FocusNode();

  final originController = TextEditingController();
  final destinationController = TextEditingController();

  bool? _originHasFocus;

  SearchPlaceController(this._searchRepository) {
    _subscription = _searchRepository.onResults.listen(
      (results) {
        print(':) results ${results?.length}, $query');
        _places = results;
        notifyListeners();
      },
    );
    originFocusNode.addListener(() {
      if (originFocusNode.hasFocus) {
        _originHasFocus = true;
      }
    });
    originFocusNode.addListener(() {
      if (destinationFocusNode.hasFocus) {
        _originHasFocus = false;
      }
    });
  }

  Timer? _debouncer;

  void onQueryChanged(String text) {
    _query = text;
    _debouncer = Timer(const Duration(milliseconds: 500), () {
      if (_query.length >= 3) {
        // ignore: avoid_print
        print('Call to API $query');
        final currentPosition = CurrentPosition.i.value;
        if (currentPosition != null) {
          _searchRepository.cancel();
          _searchRepository.search(query, currentPosition);
        }
      } else {
        // ignore: avoid_print
        print('Cancel API call');
        _searchRepository.cancel();
        _places = [];
        notifyListeners();
      }
    });
  }

  void pickPlace(Place place) {
    if (_originHasFocus!) {
      _origin = place;
      originController.text = place.title;
    } else {
      _destination = place;
      destinationController.text = place.title;
    }
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    originFocusNode.dispose();
    destinationFocusNode.dispose();
    _debouncer?.cancel();
    _subscription.cancel();
    _searchRepository.dispose();
    super.dispose();
  }
}
