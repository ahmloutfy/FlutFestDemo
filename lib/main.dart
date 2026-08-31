import 'package:device_preview/device_preview.dart';
import 'package:flutfest/core/services/notification_service.dart';
import 'package:flutfest/core/utils/my_custom_scroll_behavior.dart';
import 'package:flutfest/logic/controllers/settings_controller.dart';
import 'package:flutfest/routes.dart';
import 'package:flutfest/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'logic/controllers/user_controller.dart';

// Set to false to skip the native splash delay during development by not
// awaiting notification init before the first frame. Keep true for release.
const bool waitForNotificationInitOnStartup = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (kReleaseMode || waitForNotificationInitOnStartup) {
      await NotificationService.init();
    } else {
      NotificationService.init();
    }
  }
  await GetStorage.init();
  Get.put(UserController());

  runApp(
    DevicePreview(
      // Enabled for Web Demo (even in release) but disabled for Mobile Release
      enabled: kIsWeb || !kReleaseMode,
      builder: (context) => FlutFest(),
    ),
  );
}

class FlutFest extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());

  FlutFest({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        initialRoute: Routes.welcome,
        getPages: Routes.pages,
        debugShowCheckedModeBanner: false,
        title: 'FlutFest',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: controller.getThemeMode(),
      ),
    );
  }
}
