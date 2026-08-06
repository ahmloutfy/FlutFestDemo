import 'package:flutfest/core/utils/dummy_events.dart';
import 'package:flutfest/logic/models/event_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends GetxController {
  final RxMap<String, bool> _favoriteEvents = <String, bool>{}.obs;

  Map<String, bool> get favoriteEvents => _favoriteEvents;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('favoriteEvents') ?? [];
    for (var id in savedIds) {
      _favoriteEvents[id] = true;
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = _favoriteEvents.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    await prefs.setStringList('favoriteEvents', ids);
  }

  Future<bool> toggleFavorite(String eventId) async {
    final currentStatus = _favoriteEvents[eventId] ?? false;
    final newStatus = !currentStatus;
    _favoriteEvents[eventId] = newStatus;
    await _saveFavorites();
    update();
    return newStatus;
  }

  bool isFavorite(String eventId) {
    return _favoriteEvents.containsKey(eventId) && _favoriteEvents[eventId]!;
  }

  EventModel? getEventById(String id) {
    return DummyEvents.events.firstWhereOrNull((e) => e.eventId == id);
  }
}
