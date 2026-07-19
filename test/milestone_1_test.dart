import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishcraft/domain/entities/card_layout.dart';
import 'package:wishcraft/core/theme/card_templates.dart';
import 'package:wishcraft/data/models/wish_card_model.dart';
import 'package:wishcraft/presentation/viewmodels/card_editor_viewmodel.dart';
import 'package:wishcraft/data/models/occasion_model.dart';

void main() {
  group('M1: Data Models & Pickers Foundation Tests', () {
    test('CardLayout enum exists and has correct count', () {
      expect(CardLayout.values.length, 6);
      expect(CardLayout.classic.name, 'classic');
      expect(CardLayout.polaroid.name, 'polaroid');
    });

    test('CardTemplate retrieval works as expected', () {
      final template = getCardTemplate('template_03');
      expect(template.name, 'Midnight Star');
      expect(template.pattern, CardPattern.stars);

      final fallback = getCardTemplate('invalid_id');
      expect(fallback.id, 'template_01');
    });

    test('OccasionModel templateIds generates exactly 12 items', () {
      const occasion = OccasionModel(
        id: 'birthday',
        displayName: 'Birthday',
        emoji: '🎂',
        primaryColor: Colors.purple,
        secondaryColor: Colors.yellow,
        templateFolder: 'assets/images/templates/birthday/',
      );
      expect(occasion.templateIds.length, 12);
      expect(occasion.templateIds.first, 'template_01');
      expect(occasion.templateIds.last, 'template_12');
    });

    test('WishCardModel serialization & deserialization includes layout and thumbnailBase64', () {
      final now = DateTime.now();
      final model = WishCardModel(
        id: 'test_card_1',
        occasionId: 'birthday',
        recipientName: 'Alice',
        senderName: 'Bob',
        wishText: 'Happy Birthday!',
        templateId: 'template_02',
        fontFamily: 'Roboto',
        fontSize: 20.0,
        textColor: 0xFF00FF00,
        stickerIds: const ['sticker_1', 'sticker_2'],
        showBorder: true,
        cardLayout: CardLayout.polaroid,
        thumbnailBase64: 'data:image/png;base64,abc',
        createdAt: now,
        updatedAt: now,
      );

      final json = model.toJson();
      expect(json['cardLayout'], 'polaroid');
      expect(json['thumbnailBase64'], 'data:image/png;base64,abc');

      // Deserialize it back
      final parsed = WishCardModel.fromJson(json, 'test_card_1');
      expect(parsed.cardLayout, CardLayout.polaroid);
      expect(parsed.thumbnailBase64, 'data:image/png;base64,abc');
      expect(parsed.recipientName, 'Alice');
      expect(parsed.senderName, 'Bob');
    });

    test('CardEditorViewModel undo/redo and actions work correctly', () {
      final viewModel = CardEditorViewModel();
      expect(viewModel.state.cardLayout, CardLayout.classic);
      expect(viewModel.state.thumbnailBase64, isNull);

      // Change layout
      viewModel.setLayout(CardLayout.minimal);
      expect(viewModel.state.cardLayout, CardLayout.minimal);
      expect(viewModel.canUndo, true);

      // Change thumbnailBase64
      viewModel.setThumbnailBase64('test_base64');
      expect(viewModel.state.thumbnailBase64, 'test_base64');

      // Undo thumbnail change
      viewModel.undo();
      expect(viewModel.state.thumbnailBase64, isNull);
      expect(viewModel.state.cardLayout, CardLayout.minimal);

      // Undo layout change
      viewModel.undo();
      expect(viewModel.state.cardLayout, CardLayout.classic);

      // Redo layout change
      viewModel.redo();
      expect(viewModel.state.cardLayout, CardLayout.minimal);
    });
  });
}
