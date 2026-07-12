import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../core/errors/app_exception.dart';

class GeminiFunctionsDatasource {
  GeminiFunctionsDatasource();

  Future<List<Map<String, dynamic>>> generateWishes({
    required String occasion,
    required String recipientName,
    required String relationship,
    required String tone,
    String? personalNote,
  }) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'your_gemini_api_key_here') {
      throw const AppException(
        'Gemini API key not set. Add GEMINI_API_KEY to your .env file.',
      );
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      final personalNoteText = (personalNote != null && personalNote.isNotEmpty)
          ? 'Personal note: $personalNote'
          : '';

      final prompt = '''
Generate exactly 3 heartfelt, unique wish messages for a $occasion occasion.
Recipient: $recipientName
Relationship: $relationship
Tone: $tone
$personalNoteText

Rules:
- Each wish must be on its own line, starting with "---WISH---"
- Do NOT use JSON, bullet points, or numbering
- Each wish should be 2-4 sentences, warm and personal
- Vary the style across the 3 wishes

Format exactly like this:
---WISH---
[First wish text here]
---WISH---
[Second wish text here]
---WISH---
[Third wish text here]
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw const AppException('No response from Gemini. Please try again.');
      }

      // Parse the response into 3 wish variants
      final parts = text.split('---WISH---').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

      if (parts.isEmpty) {
        throw const AppException('Could not parse wishes. Please try again.');
      }

      return List.generate(parts.length > 3 ? 3 : parts.length, (i) => {
        'id': 'v${i + 1}',
        'text': parts[i],
      });
    } on AppException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('API_KEY_INVALID') ||
          e.toString().contains('invalid API key') ||
          e.toString().contains('400')) {
        throw const AppException(
          'Invalid Gemini API key. Check your .env file.',
        );
      }
      if (e.toString().contains('quota') || e.toString().contains('429')) {
        throw const AppException(
          "You've reached the generation limit. Please try again later.",
        );
      }
      throw AppException('Something went wrong generating wishes. Please try again.');
    }
  }
}
