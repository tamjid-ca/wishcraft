import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

Future<Uint8List> captureCardAsPng(GlobalKey repaintKey, {double pixelRatio = 3.0}) async {
  await Future.delayed(const Duration(milliseconds: 150));
  final boundary =
      repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) throw Exception('RepaintBoundary not found.');
  final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) throw Exception('Failed to convert image.');
  return byteData.buffer.asUint8List();
}
