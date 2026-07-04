import '../models/wish_variant_model.dart';
import '../services/gemini_service.dart';
import 'ai_repository.dart';

class AiRepositoryImpl implements AiRepository {
  final GeminiService _geminiService;
  AiRepositoryImpl(this._geminiService);

  @override
  Future<List<WishVariantModel>> generateWishes({
    required String occasionId,
    required String recipientName,
    required String relationship,
    required String tone,
    String? personalNote,
  }) {
    return _geminiService.generateWishVariants(
      occasion: occasionId,
      recipientName: recipientName,
      relationship: relationship,
      tone: tone,
      personalNote: personalNote,
    );
  }
}
