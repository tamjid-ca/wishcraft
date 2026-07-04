import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/wish_card_model.dart';
import '../../data/repositories/card_repository.dart';

class SavedCardsState extends Equatable {
  final AsyncValue<List<WishCardModel>> cards;
  final String? filterOccasionId;

  const SavedCardsState({
    this.cards = const AsyncValue.loading(),
    this.filterOccasionId,
  });

  List<WishCardModel> get filteredCards {
    final all = cards.value ?? [];
    if (filterOccasionId == null) return all;
    return all.where((c) => c.occasionId == filterOccasionId).toList();
  }

  SavedCardsState copyWith({
    AsyncValue<List<WishCardModel>>? cards,
    String? filterOccasionId,
    bool clearFilter = false,
  }) {
    return SavedCardsState(
      cards: cards ?? this.cards,
      filterOccasionId: clearFilter ? null : (filterOccasionId ?? this.filterOccasionId),
    );
  }

  @override
  List<Object?> get props => [cards, filterOccasionId];
}

class SavedCardsViewModel extends StateNotifier<SavedCardsState> {
  final CardRepository _repository;

  SavedCardsViewModel(this._repository) : super(const SavedCardsState()) {
    _subscribeToCards();
  }

  void _subscribeToCards() {
    _repository.watchCards().listen(
      (cards) => state = state.copyWith(cards: AsyncValue.data(cards)),
      onError: (e, st) => state = state.copyWith(cards: AsyncValue.error(e, st)),
    );
  }

  Future<void> deleteCard(String cardId) async {
    await _repository.deleteCard(cardId);
  }

  void filterByOccasion(String? occasionId) {
    if (occasionId == null) {
      state = state.copyWith(clearFilter: true);
    } else {
      state = state.copyWith(filterOccasionId: occasionId);
    }
  }
}
