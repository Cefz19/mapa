import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapa_1/src/ui/page/home/controller/home_controller.dart';
import 'package:mapa_1/src/ui/page/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

class WhereAreYouGoingButton extends StatelessWidget {
  const WhereAreYouGoingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 35,
      left: 20,
      right: 20,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CupertinoButton(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              onPressed: context.read<HomeController>().zoomIn,
              child: const Icon(
                Icons.add,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            CupertinoButton(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              onPressed: context.read<HomeController>().zoomOut,
              child: const Icon(
                Icons.remove,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              onPressed: () async {
                final route = MaterialPageRoute<SearchResponse>(
                  builder: (_) => const SearchPlacePage(),
                );
                final response = await Navigator.push<SearchResponse>(
                  context,
                  route,
                );
                if (response != null) {
                  // ignore: use_build_context_synchronously
                  final controller = context.read<HomeController>();
                  controller.setOriginAndDestination(
                    response.origin,
                    response.destination,
                  );
                }
              },
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'A donde quieres ir',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
