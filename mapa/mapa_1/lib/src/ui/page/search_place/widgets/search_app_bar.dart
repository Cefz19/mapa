import 'package:flutter/material.dart';
import 'package:mapa_1/src/ui/page/search_place/search_place_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../search_place_controller.dart';

class SearchAppBar extends StatelessWidget with PreferredSizeWidget {
  const SearchAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.black87,
      ),
      elevation: 0,
      actions: [
        Builder(
          builder: (context) {
            final controller = context.watch<SearchPlaceController>();
            final origin = controller.origin;
            final destination = controller.destination;
            final bool enabled = origin != null && destination != null;
            return CupertinoButton(
              // ignore: sort_child_properties_last
              child: const Text('SAVE'),
              onPressed: enabled
                  ? () {
                      Navigator.pop(
                          context, SearchResponse(origin, destination));
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
