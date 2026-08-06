import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  void setIndex(int index) {
    currentIndex.value = index;
  }

  void goToHomeTab() => currentIndex.value = 0;
  void goToMyEventsTab() => currentIndex.value = 1;
  void goToAccountTab() => currentIndex.value = 2;
}