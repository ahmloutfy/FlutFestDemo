import 'package:flutfest/logic/controllers/event_controller.dart';
import 'package:flutfest/logic/controllers/user_controller.dart';
import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:get/get.dart';

Future<void> handleAttendance(String eventId) async {
  final eventController = Get.find<EventController>();
  final userController = Get.find<UserController>();

  final result = await eventController.toggleAttendance(
    eventId,
    userController.currentUserId.value,
  );

  switch (result) {
    case AttendanceResult.attending:
      showCustomSnackBar('You are now attending this event!');
      break;
    case AttendanceResult.cancelled:
      showCustomSnackBar('You cancelled your attending.');
      break;
    case AttendanceResult.expired:
      showCustomSnackBar('Event has already ended.');
      break;
  }
}
