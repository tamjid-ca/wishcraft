import 'package:cloud_functions/cloud_functions.dart';
import '../../../core/errors/app_exception.dart';

class GeminiFunctionsDatasource {
  final FirebaseFunctions _functions;
  GeminiFunctionsDatasource(this._functions);

  Future<List<Map<String, dynamic>>> generateWishes({
    required String occasion,
    required String recipientName,
    required String relationship,
    required String tone,
    String? personalNote,
  }) async {
    try {
      final callable = _functions.httpsCallable(
        'generateWishes',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );

      final result = await callable.call<Map<String, dynamic>>({
        'occasion': occasion,
        'recipientName': recipientName,
        'relationship': relationship,
        'tone': tone,
        if (personalNote != null && personalNote.isNotEmpty)
          'personalNote': personalNote,
      });

      final variants = (result.data['variants'] as List).cast<Map<String, dynamic>>();
      if (variants.isEmpty) {
        throw const AppException('Could not generate wishes. Try again.');
      }
      return variants;
    } on FirebaseFunctionsException catch (e) {
      throw AppException(_mapFunctionsError(e));
    }
  }

  String _mapFunctionsError(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'unauthenticated':
        return 'Please sign in again to generate wishes.';
      case 'resource-exhausted':
        return e.message ?? "You've reached today's generation limit. Try again tomorrow.";
      case 'invalid-argument':
        return 'Please fill in all required fields.';
      case 'deadline-exceeded':
        return 'That took too long. Please try again.';
      default:
        return 'Something went wrong generating wishes. Please try again.';
    }
  }
}
