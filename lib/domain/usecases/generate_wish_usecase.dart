import '../../data/models/wish_variant_model.dart';
import '../../data/repositories/ai_repository.dart';

class GenerateWishParams {
  final String occasionId;
  final String recipientName;
  final String relationship;
  final String tone;
  final String? personalNote;

  const GenerateWishParams({
    required this.occasionId,
    required this.recipientName,
    required this.relationship,
    required this.tone,
    this.personalNote,
  });
}

class GenerateWishUsecase {
  final AiRepository _repository;
  GenerateWishUsecase(this._repository);

  Future<List<WishVariantModel>> call(GenerateWishParams params) {
    return _repository.generateWishes(
      occasionId: params.occasionId,
      recipientName: params.recipientName,
      relationship: params.relationship,
      tone: params.tone,
      personalNote: params.personalNote,
    );
  }
}
