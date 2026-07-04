import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

class CardEditorState extends Equatable {
  final String selectedTemplateId;
  final String fontFamily;
  final double fontSize;
  final int textColor;
  final List<String> appliedStickerIds;
  final bool showBorder;
  final String senderName;
  final bool showRecipientName;

  const CardEditorState({
    this.selectedTemplateId = 'template_01',
    this.fontFamily = 'Playfair Display',
    this.fontSize = 18.0,
    this.textColor = 0xFFFFFFFF,
    this.appliedStickerIds = const [],
    this.showBorder = false,
    this.senderName = '',
    this.showRecipientName = true,
  });

  Color get textColorValue => Color(textColor);

  CardEditorState copyWith({
    String? selectedTemplateId,
    String? fontFamily,
    double? fontSize,
    int? textColor,
    List<String>? appliedStickerIds,
    bool? showBorder,
    String? senderName,
    bool? showRecipientName,
  }) {
    return CardEditorState(
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      appliedStickerIds: appliedStickerIds ?? this.appliedStickerIds,
      showBorder: showBorder ?? this.showBorder,
      senderName: senderName ?? this.senderName,
      showRecipientName: showRecipientName ?? this.showRecipientName,
    );
  }

  @override
  List<Object?> get props => [
        selectedTemplateId,
        fontFamily,
        fontSize,
        textColor,
        appliedStickerIds,
        showBorder,
        senderName,
        showRecipientName,
      ];
}

class CardEditorViewModel extends StateNotifier<CardEditorState> {
  final List<CardEditorState> _history = [];
  int _historyIndex = -1;
  static const int _maxHistory = 20;

  CardEditorViewModel() : super(const CardEditorState()) {
    _pushHistory(const CardEditorState());
  }

  void _pushHistory(CardEditorState newState) {
    // Truncate future if we've undone
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    _history.add(newState);
    if (_history.length > _maxHistory) _history.removeAt(0);
    _historyIndex = _history.length - 1;
  }

  void _updateState(CardEditorState newState) {
    _pushHistory(newState);
    state = newState;
  }

  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _history.length - 1;

  void undo() {
    if (!canUndo) return;
    _historyIndex--;
    state = _history[_historyIndex];
  }

  void redo() {
    if (!canRedo) return;
    _historyIndex++;
    state = _history[_historyIndex];
  }

  void selectTemplate(String id) => _updateState(state.copyWith(selectedTemplateId: id));
  void setFont(String fontFamily) => _updateState(state.copyWith(fontFamily: fontFamily));
  void setFontSize(double size) => _updateState(state.copyWith(fontSize: size));
  void setTextColor(Color color) => _updateState(state.copyWith(textColor: color.value));
  void setSenderName(String name) => _updateState(state.copyWith(senderName: name));
  void toggleBorder() => _updateState(state.copyWith(showBorder: !state.showBorder));
  void toggleRecipientName() =>
      _updateState(state.copyWith(showRecipientName: !state.showRecipientName));

  void addSticker(String stickerId) {
    final updated = [...state.appliedStickerIds, stickerId];
    _updateState(state.copyWith(appliedStickerIds: updated));
  }

  void removeSticker(String stickerId) {
    final updated = state.appliedStickerIds.where((s) => s != stickerId).toList();
    _updateState(state.copyWith(appliedStickerIds: updated));
  }

  void initFromCard({
    String? templateId,
    String? fontFamily,
    double? fontSize,
    int? textColor,
    List<String>? stickerIds,
    bool? showBorder,
    String? senderName,
  }) {
    final newState = CardEditorState(
      selectedTemplateId: templateId ?? state.selectedTemplateId,
      fontFamily: fontFamily ?? state.fontFamily,
      fontSize: fontSize ?? state.fontSize,
      textColor: textColor ?? state.textColor,
      appliedStickerIds: stickerIds ?? state.appliedStickerIds,
      showBorder: showBorder ?? state.showBorder,
      senderName: senderName ?? state.senderName,
    );
    _pushHistory(newState);
    state = newState;
  }
}
