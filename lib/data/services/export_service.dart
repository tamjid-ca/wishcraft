import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:saver_gallery/saver_gallery.dart';
import '../../core/errors/app_exception.dart';

import 'package:permission_handler/permission_handler.dart';

class ExportService {
  Future<File> exportAsPng(
    GlobalKey repaintKey,
    String filename, {
    double pixelRatio = 3.0,
  }) async {
    final bytes = await _captureWidget(repaintKey, pixelRatio: pixelRatio);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename.png');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<String> exportThumbnailBase64(GlobalKey repaintKey) async {
    final bytes = await _captureWidget(repaintKey, pixelRatio: 1.0);
    return base64Encode(bytes);
  }

  /// Low-res capture used only for the gallery thumbnail.
  Future<File> exportThumbnail(GlobalKey repaintKey, String filename) =>
      exportAsPng(repaintKey, '${filename}_thumb', pixelRatio: 1.0);

  Future<File> exportAsPdf(GlobalKey repaintKey, String filename) async {
    final pngBytes = await _captureWidget(repaintKey, pixelRatio: 3.0);
    final pdf = pw.Document();
    final image = pw.MemoryImage(pngBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          PdfPageFormat.a4.width,
          PdfPageFormat.a4.width,
        ),
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) => pw.Image(image, fit: pw.BoxFit.cover),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<bool> _requestGalleryPermission() async {
    if (!Platform.isAndroid && !Platform.isIOS) return true;

    if (Platform.isAndroid) {
      final versionStr = Platform.operatingSystemVersion;
      int sdkVersion = 0;
      final apiMatch = RegExp(r'API\s+(\d+)').firstMatch(versionStr);
      if (apiMatch != null) {
        sdkVersion = int.tryParse(apiMatch.group(1) ?? '') ?? 0;
      } else {
        final numMatch = RegExp(r'(\d+)').firstMatch(versionStr);
        if (numMatch != null) {
          sdkVersion = int.tryParse(numMatch.group(1) ?? '') ?? 0;
        }
      }

      if (sdkVersion >= 33) {
        final status = await Permission.photos.request();
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return true;
  }

  Future<bool> saveToGallery(File file) async {
    final path = file.path;
    if (path.endsWith('.png') || path.endsWith('.jpg')) {
      final hasPermission = await _requestGalleryPermission();
      if (!hasPermission) {
        throw const AppException('Permission denied');
      }

      final result = await SaverGallery.saveFile(
        file: path,
        name: 'wishcraft_${DateTime.now().millisecondsSinceEpoch}.png',
        androidRelativePath: 'Pictures/WishCraft',
        androidExistNotSave: false,
      );
      return result.isSuccess;
    } else if (path.endsWith('.pdf')) {
      final downloadsDir = await getApplicationDocumentsDirectory();
      final dest = File('${downloadsDir.path}/${file.uri.pathSegments.last}');
      await file.copy(dest.path);
      return true;
    }
    return false;
  }

  Future<Uint8List> _captureWidget(
    GlobalKey repaintKey, {
    double pixelRatio = 3.0,
  }) async {
    try {
      final boundary =
          repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw const AppException('Card widget not found. Try again.');
      }
      await Future.delayed(const Duration(milliseconds: 100));
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw const AppException('Failed to capture card image.');
      }
      return byteData.buffer.asUint8List();
    } catch (e) {
      throw AppException('Export failed: ${e.toString()}');
    }
  }
}
