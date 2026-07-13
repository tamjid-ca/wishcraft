import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/wish_variant_model.dart';
import '../../domain/usecases/generate_wish_usecase.dart';

class WishGeneratorState extends Equatable {
  final AsyncValue<List<WishVariantModel>> wishVariants;
  final int? selectedIndex;
  final String recipientName;
  final String relationship;
  final String personalNote;
  final String tone;

  const WishGeneratorState({
    this.wishVariants = const AsyncValue.data([]),
    this.selectedIndex,
    this.recipientName = '',
    this.relationship = 'Friend',
    this.personalNote = '',
    this.tone = 'Heartfelt',
  });

  bool get isFormValid => recipientName.trim().isNotEmpty;

  WishVariantModel? get selectedVariant =>
      selectedIndex != null && wishVariants.valueOrNull != null && selectedIndex! < wishVariants.valueOrNull!.length
          ? wishVariants.valueOrNull![selectedIndex!]
          : null;

  WishGeneratorState copyWith({
    AsyncValue<List<WishVariantModel>>? wishVariants,
    int? selectedIndex,
    bool clearSelectedIndex = false,
    String? recipientName,
    String? relationship,
    String? personalNote,
    String? tone,
  }) =>
      WishGeneratorState(
        wishVariants: wishVariants ?? this.wishVariants,
        selectedIndex: clearSelectedIndex ? null : (selectedIndex ?? this.selectedIndex),
        recipientName: recipientName ?? this.recipientName,
        relationship: relationship ?? this.relationship,
        personalNote: personalNote ?? this.personalNote,
        tone: tone ?? this.tone,
      );

  @override
  List<Object?> get props =>
      [wishVariants, selectedIndex, recipientName, relationship, personalNote, tone];
}

class WishGeneratorViewModel extends StateNotifier<WishGeneratorState> {
  final GenerateWishUsecase _generateWishUsecase;
  final String occasionId;

  WishGeneratorViewModel(this._generateWishUsecase, this.occasionId)
      : super(const WishGeneratorState());

  void setRecipientName(String name) => state = state.copyWith(recipientName: name);
  void setRelationship(String rel) => state = state.copyWith(relationship: rel);
  void setPersonalNote(String note) => state = state.copyWith(personalNote: note);
  void setTone(String tone) => state = state.copyWith(tone: tone);
  void selectVariant(int index) => state = state.copyWith(selectedIndex: index);

  void editVariantText(int index, String newText) {
    final current = state.wishVariants.valueOrNull;
    if (current == null || index >= current.length) return;
    final updated = List<WishVariantModel>.from(current);
    updated[index] = updated[index].copyWith(text: newText);
    state = state.copyWith(wishVariants: AsyncValue.data(updated));
  }

  Future<void> generateWishes() async {
    if (!state.isFormValid) return;
    state = state.copyWith(
      wishVariants: const AsyncValue.loading(),
      clearSelectedIndex: true,
    );
    try {
      final variants = await _generateWishUsecase.call(
        GenerateWishParams(
          occasionId: occasionId,
          recipientName: state.recipientName,
          relationship: state.relationship,
          tone: state.tone,
          personalNote: state.personalNote.isEmpty ? null : state.personalNote,
        ),
      );
      state = state.copyWith(wishVariants: AsyncValue.data(variants));
    } catch (e, st) {
      state = state.copyWith(wishVariants: AsyncValue.error(e, st));
    }
  }

  Future<void> regenerateVariant(int index) async {
    final current = state.wishVariants.valueOrNull;
    if (current == null) return;
    try {
      final fresh = await _generateWishUsecase.call(
        GenerateWishParams(
          occasionId: occasionId,
          recipientName: state.recipientName,
          relationship: state.relationship,
          tone: state.tone,
          personalNote: state.personalNote.isEmpty ? null : state.personalNote,
        ),
      );
      final updated = List<WishVariantModel>.from(current);
      if (fresh.isNotEmpty) updated[index] = fresh.first;
      state = state.copyWith(wishVariants: AsyncValue.data(updated));
    } catch (_) {
      rethrow;
    }
  }
}
