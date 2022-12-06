import 'package:flutter/cupertino.dart' show ChangeNotifier;

class SearchPlaceController extends ChangeNotifier {
  String _query = '';
  String get query => _query;

  void onQueryChanged(String text) {
    _query = text;
  }
}
