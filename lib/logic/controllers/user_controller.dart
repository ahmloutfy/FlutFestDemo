import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class UserController extends GetxController {
  final Uuid userUuid = Uuid();
  var currentUserId = ''.obs;
}