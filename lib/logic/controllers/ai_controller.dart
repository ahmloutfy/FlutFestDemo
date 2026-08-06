import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIController extends GetxController {
  final _apiKey = 'AIzaSyAFjAwgUvo6QWMI9Z2OFuIlHq7kLeg9I9k';
  late GenerativeModel _model;

  @override
  void onInit() {
    super.onInit();
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
  }

  Future<String> suggestEventDescription(String eventTitle) async {
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