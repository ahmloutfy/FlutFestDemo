import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:flutfest/constants.dart';

class AIService {
  /// Generate a complete event from a simple idea (Global Version)
  Future<Map<String, dynamic>> generateEventFromIdea(String userIdea) async {
    final apiKey = AppConstants.geminiApiKey;
    if (apiKey.isEmpty) {
      throw Exception(
        'Gemini is not configured. Run with --dart-define=GEMINI_API_KEY=<new-key>.',
      );
    }

    final prompt = '''
You are an expert international event organizer.

User's idea: "$userIdea"

Create the following in a professional and attractive way:

1. Catchy event title (maximum 70 characters)
2. Full engaging description (100-200 words)
3. Suggested location or venue/city based on idea (e.g. "Cairo Festival City", "Online Webinar", "Dubai Media City")
4. Relevant tags (5-8 keywords separated by commas)
5. Event category (Workshop, Conference, Concert, Networking, Exhibition, Party, Seminar, etc.)

Return ONLY a valid JSON object in this exact format with no extra text:

{
  "title": "...",
  "description": "...",
  "location": "...",
  "tags": "tag1, tag2, tag3",
  "category": "..."
}
''';

    Object? lastError;

    for (final modelName in ['gemini-3.8-flash']) {
      try {
        final model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
        );
        final content = [Content.text(prompt)];
        debugPrint('AIService: sending event generation request');
        final response = await model
            .generateContent(content)
            .timeout(const Duration(seconds: 45));
        final text = response.text ?? '';
        debugPrint('AIService: response received (${text.length} characters)');

        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(text);
        if (jsonMatch == null) {
          throw const FormatException('Gemini returned no JSON event data.');
        }

        final parsed = Map<String, dynamic>.from(
          json.decode(jsonMatch.group(0)!) as Map,
        );
        if (parsed['title'] == null || parsed['description'] == null) {
          throw const FormatException(
            'Gemini response is missing the event title or description.',
          );
        }
        return parsed;
      } catch (e) {
        debugPrint('AIService attempt failed ($modelName): $e');
        lastError = e;
      }
    }

    throw Exception('AI generation failed: $lastError');
  }
}
