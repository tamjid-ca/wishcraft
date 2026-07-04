import '../datasources/remote/gemini_functions_datasource.dart';
import '../models/wish_variant_model.dart';

class GeminiService {
  final GeminiFunctionsDatasource _datasource;
  GeminiService(this._datasource);

  Future<List<WishVariantModel>> generateWishVariants({
    required String occasion,
    required String recipientName,
    required String relationship,
    required String tone,
    String? personalNote,
  }) async {
    final raw = await _datasource.generateWishes(
      occasion: occasion,
      recipientName: recipientName,
      relationship: relationship,
      tone: tone,
      personalNote: personalNote,
    );

    return raw
        .map((v) => WishVariantModel(
              id: v['id'] as String,
              text: v['text'] as String,
              isSelected: false,
            ))
        .toList();
  }
}
