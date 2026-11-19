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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage first as it's usually fast and needed by controllers
  await GetStorage.init();

  Get.put(UserController());

  runApp(
    DevicePreview(
      enabled: kIsWeb || !kReleaseMode,
      builder: (context) => FlutFest(),
    ),
  );

  // Run notification service in background AFTER runApp so splash screen closes immediately
  if (!kIsWeb) {
    NotificationService.init().catchError((e) => debugPrint('Notification init error: $e'));
  }
}

class FlutFest extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());

  FlutFest({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      initialRoute: Routes.welcome,
      getPages: Routes.pages,
      debugShowCheckedModeBanner: false,
      title: 'FlutFest',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: controller.getThemeMode(),
    );
  }
}
