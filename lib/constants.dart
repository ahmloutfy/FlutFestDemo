class AppConstants {
  /// Provide with --dart-define=GEMINI_API_KEY=... at build/run time.
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  /// Provide with --dart-define=GOOGLE_MAPS_API_KEY=... at build/run time.
  static const String googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
}
