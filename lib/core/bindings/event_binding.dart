import 'package:flutfest/logic/controllers/event_controller.dart';
import 'package:get/get.dart';
import 'package:flutfest/logic/models/create_event_view_model.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EventController>(EventController(), permanent: true);
  }
}

/// Dependencies only needed by the create/edit event flows. Keeping them out
/// of [EventBinding] prevents web-incompatible file and geocoding code from
/// being instantiated merely by opening the home page.
class CreateEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EventController>(EventController(), permanent: true);
    Get.put<CreateEventViewModel>(CreateEventViewModel(), permanent: true);
  }
}
