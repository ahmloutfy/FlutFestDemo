import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class AIService {
  // TODO: Replace this with your real Gemini API Key
  static const String _apiKey = 'AIzaSyCFJ6LOaX5KpnnCBuCLpvNUSfsXcarZ5pw';

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
  );

  /// Generate a complete event from a simple idea (Global Version)
  Future<Map<String, dynamic>> generateEventFromIdea(String userIdea) async {
    final prompt = '''
You are an expert international event organizer.

User's idea: "$userIdea"

Create the following in a professional and attractive way:

1. Catchy event title (maximum 70 characters)
2. Full engaging description (150-300 words)
3. Relevant tags (5-8 keywords separated by commas)
4. Event category (Workshop, Conference, Concert, Networking, Exhibition, Party, Seminar, etc.)

Return ONLY a valid JSON in this exact format:

{
  "title": "...",
  "description": "...",
  "tags": "tag1, tag2, tag3, ...",
  "category": "..."
}
''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final text = response.text ?? '';

      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(text);

      if (jsonMatch != null) {
        return json.decode(jsonMatch.group(0)!);
      } else {
        throw Exception('Failed to parse AI response');
      }
    } catch (e) {
      throw Exception('AI generation failed: $e');
    }
  }
}