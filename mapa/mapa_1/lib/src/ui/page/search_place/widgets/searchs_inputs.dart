import 'package:flutter/material.dart';
import 'package:mapa_1/src/ui/page/search_place/widgets/search_input.dart';
import 'package:provider/provider.dart';

import '../search_place_controller.dart';

class SearchInputs extends StatelessWidget {
  const SearchInputs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        Provider.of<SearchPlaceController>(context, listen: false);
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
  }
}
