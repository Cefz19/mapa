import 'dart:ui' as ui;

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../domain/models/place.dart';
import '../../widgets/custom_marker.dart';

Future<BitmapDescriptor> placeToMarker(Place place, int? duration) async {
  final recoder = ui.PictureRecorder();
  final canvas = ui.Canvas(recoder);
  const size = ui.Size(350, 70);

  final customMarker = MyCustomMarker(
    label: place.title,
    duartion: duration,
  );
  customMarker.paint(canvas, size);
  final picture = recoder.endRecording();
  final image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  final byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  final byte = byteData!.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(byte);
}
