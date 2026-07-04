import 'dart:io';
import '../../data/models/wish_card_model.dart';
import '../../data/repositories/card_repository.dart';

class SaveCardUsecase {
  final CardRepository _repository;
  SaveCardUsecase(this._repository);

  Future<void> call(WishCardModel card, {File? thumbnailFile}) {
    return _repository.saveCard(card, thumbnailFile: thumbnailFile);
  }
}
