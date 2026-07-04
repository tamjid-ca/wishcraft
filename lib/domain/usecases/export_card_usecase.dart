import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/services/export_service.dart';

class ExportCardUsecase {
  final ExportService _exportService;
  ExportCardUsecase(this._exportService);

  Future<File> exportAsPng(GlobalKey repaintKey, String filename) =>
      _exportService.exportAsPng(repaintKey, filename);

  Future<File> exportAsPdf(GlobalKey repaintKey, String filename) =>
      _exportService.exportAsPdf(repaintKey, filename);
}
