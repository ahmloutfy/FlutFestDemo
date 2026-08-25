import 'package:flutfest/routes.dart';
import 'package:flutfest/theme.dart';
import 'package:flutfest/widgets/backgrounds/intro_background.dart';
import 'package:flutfest/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/platform_ads.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Request native notification permissions only after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!kIsWeb) {
        NotificationService.requestPermissions();
        initializeMobileAds();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color translucentBlue = AppTheme.getColorForTheme(
      context: context,
      lightModeColor: AppTheme.lightButtonColor.withValues(alpha: 0.2),
      darkModeColor: AppTheme.darkButtonColor.withValues(alpha: 0.2),
    );

    return Scaffold(
      body: IntroBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: width * 0.9,
                    height: height * 0.3,
                    fit: BoxFit.contain,
                  ),
                ),
                // Welcome Text
                Text(
                  'Welcome to FlutFest!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: width * 0.08,
                  ),
                ),
                Gutter(),

                // Description Text
                Text(
                  'Manage and explore events seamlessly.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: width * 0.05,
                  ),
                ),
                Gutter(),

                // Login Button
                SizedBox(
                  width: width * 0.6,
                  child: PrimaryButton(
                    text: 'Login',
                    onPressed: () {
                      Get.offAllNamed(Routes.login);
                    },
                  ),
                ),
                Gutter(),

                // Register Button
                SizedBox(
                  width: width * 0.6,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: translucentBlue,
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Get.offAllNamed(Routes.register);

                    },
                    child: const Text('Register'),
                  ),
                ),
                Gutter(),

                // Temporary Preview Button for screen package navigation
                if (kDebugMode)
                  SizedBox(
                    width: width * 0.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: translucentBlue,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.home);
                      },
                      child: const Text('Explore UI Screens'),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
