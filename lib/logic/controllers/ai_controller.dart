import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutfest/constants.dart';

class AIController extends GetxController {
  late GenerativeModel _model;

  @override
  void onInit() {
    super.onInit();
    final apiKey = AppConstants.geminiApiKey;
    if (apiKey.isNotEmpty) {
      _model = GenerativeModel(model: 'gemini-3.8-flash', apiKey: apiKey);
    }
  }

  Future<String> suggestEventDescription(String eventTitle) async {
    if (AppConstants.geminiApiKey.isEmpty) {
      return 'Gemini is not configured. Provide GEMINI_API_KEY at build time.';
    }
    try {
      final prompt = "I'm organizing an event called '$eventTitle'. Give me a catchy, short description for it.";
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "No description generated.";
    } catch (e) {
      return "Error: $e";
    }
  }
}