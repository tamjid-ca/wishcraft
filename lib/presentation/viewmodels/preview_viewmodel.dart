import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/wish_card_model.dart';
import '../../data/services/export_service.dart';
import '../../data/services/share_service.dart';
import '../../domain/usecases/save_card_usecase.dart';
import 'package:share_plus/share_plus.dart';

class PreviewState extends Equatable {
  final bool isExporting;
  final bool isSaving;
  final bool isSaved;
  final bool isGallerySaved;
  final String? exportedFilePath;
  final String? errorMessage;

  const PreviewState({
    this.isExporting = false,
    this.isSaving = false,
    this.isSaved = false,
    this.isGallerySaved = false,
    this.exportedFilePath,
    this.errorMessage,
  });

  PreviewState copyWith({
    bool? isExporting,
    bool? isSaving,
    bool? isSaved,
    bool? isGallerySaved,
    String? exportedFilePath,
    String? errorMessage,
  }) {
    return PreviewState(
      isExporting: isExporting ?? this.isExporting,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      isGallerySaved: isGallerySaved ?? this.isGallerySaved,
      exportedFilePath: exportedFilePath ?? this.exportedFilePath,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isExporting, isSaving, isSaved, isGallerySaved, exportedFilePath, errorMessage];
}

class PreviewViewModel extends StateNotifier<PreviewState> {
  final ExportService _exportService;
  final ShareService _shareService;
  final SaveCardUsecase _saveCardUsecase;

  PreviewViewModel(this._exportService, this._shareService, this._saveCardUsecase)
      : super(const PreviewState());

  Future<void> saveCard(WishCardModel card, GlobalKey repaintKey) async {
    if (state.isSaving) return;
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final base64String = await _exportService.exportThumbnailBase64(repaintKey);
      final updatedCard = card.copyWith(thumbnailBase64: base64String);
      await _saveCardUsecase.call(updatedCard);
      state = state.copyWith(isSaving: false, isSaved: true);
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
    }
  }

  Future<File?> exportAsPng(GlobalKey repaintKey, String name) async {
    state = state.copyWith(isExporting: true, errorMessage: null);
    try {
      final file = await _exportService.exportAsPng(repaintKey, name);
      final success = await _exportService.saveToGallery(file);
      if (success) {
        state = state.copyWith(isExporting: false, exportedFilePath: file.path, isGallerySaved: true);
      } else {
        throw const FormatException('Failed to save to gallery');
      }
      return file;
    } catch (e) {
      state = state.copyWith(isExporting: false, errorMessage: e.toString());
      return null;
    }
  }

  Future<File?> exportAsPdf(GlobalKey repaintKey, String name) async {
    state = state.copyWith(isExporting: true, errorMessage: null);
    try {
      final file = await _exportService.exportAsPdf(repaintKey, name);
      await Share.shareXFiles([XFile(file.path)]);
      state = state.copyWith(isExporting: false, exportedFilePath: file.path);
      return file;
    } catch (e) {
      state = state.copyWith(isExporting: false, errorMessage: e.toString());
      return null;
    }
  }

  Future<void> shareImage(GlobalKey repaintKey, {String? wishText}) async {
    state = state.copyWith(isExporting: true, errorMessage: null);
    try {
      final file = await _exportService.exportAsPng(repaintKey, 'share_${DateTime.now().millisecondsSinceEpoch}');
      await _shareService.shareAsImage(file, text: wishText);
      state = state.copyWith(isExporting: false);
    } catch (e) {
      state = state.copyWith(isExporting: false, errorMessage: e.toString());
    }
  }

  Future<void> saveToGallery(GlobalKey repaintKey) async {
    state = state.copyWith(isExporting: true, errorMessage: null);
    try {
      final file = await _exportService.exportAsPng(repaintKey, 'wishcraft_${DateTime.now().millisecondsSinceEpoch}');
      final success = await _exportService.saveToGallery(file);
      if (success) {
        state = state.copyWith(isExporting: false, isGallerySaved: true);
      } else {
        throw const FormatException('Failed to save to gallery');
      }
    } catch (e) {
      state = state.copyWith(isExporting: false, errorMessage: e.toString());
    }
  }

  void clearError() => state = state.copyWith(errorMessage: null);
  void clearGallerySaved() => state = state.copyWith(isGallerySaved: false);
}
