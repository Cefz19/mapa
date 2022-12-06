import 'dart:async';

import 'package:flutter/cupertino.dart' show ChangeNotifier;

class SearchPlaceController extends ChangeNotifier {
  String _query = '';
  String get query => _query;

  Timer? _debouncer;

  void onQueryChanged(String text) {
    _query = text;
    _debouncer = Timer(const Duration(milliseconds: 400), () {
      if (_query.length >= 3) {
        print('Call to API');
      } else {
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
