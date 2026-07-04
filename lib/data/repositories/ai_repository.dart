import '../models/wish_variant_model.dart';

abstract class AiRepository {
  Future<List<WishVariantModel>> generateWishes({
    required String occasionId,
    required String recipientName,
    required String relationship,
    required String tone,
    String? personalNote,
  });
}
