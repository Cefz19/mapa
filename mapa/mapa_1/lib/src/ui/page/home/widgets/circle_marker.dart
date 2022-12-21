import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getDotMarker() async {
  final recoder = ui.PictureRecorder();
  final canvas = ui.Canvas(recoder);
  const size = ui.Size(30, 30);

  final customMarker = CircleMarker();
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

class CircleMarker extends CustomPainter {
  CircleMarker();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    paint.color = Colors.black12;
    canvas.drawCircle(
      center,
      size.width * 0.5,
      paint,
    );
    paint.color = Colors.white;
    canvas.drawCircle(
      center,
      size.width * 0.3,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
