import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    final apiKey = dotenv.env['OPENROUTER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'your_openrouter_api_key_here') {
      throw const AppException(
        'OpenRouter API key not set. Add OPENROUTER_API_KEY to your .env file.',
      );
    }

    final modelName = dotenv.env['OPENROUTER_MODEL'] ?? 'openrouter/free';

    try {
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

      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://github.com/com-example-wishcraft/wishcraft',
          'X-Title': 'WishCraft App',
        },
        body: jsonEncode({
          'model': modelName,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode != 200) {
        final errBody = jsonDecode(response.body);
        final errMsg = errBody['error']?['message'] ?? 'Status code: ${response.statusCode}';
        throw AppException('OpenRouter API Error: $errMsg');
      }

      final data = jsonDecode(response.body);
      final text = data['choices']?[0]?['message']?['content'] as String?;

      if (text == null || text.isEmpty) {
        throw const AppException('No response from OpenRouter. Please try again.');
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
    } catch (e, st) {
      print('Error generating wishes via OpenRouter: $e');
      print(st);
      throw AppException('Something went wrong generating wishes. Please try again.');
    }
  }
}
