import 'dart:io';
import '../models/wish_card_model.dart';

abstract class CardRepository {
  Stream<List<WishCardModel>> watchCards();
  Future<void> saveCard(WishCardModel card, {File? thumbnailFile});
  Future<void> deleteCard(String cardId);
}
