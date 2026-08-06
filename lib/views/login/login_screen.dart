import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:flutfest/routes.dart';
import 'package:flutfest/theme.dart';
import 'package:flutfest/widgets/backgrounds/intro_background.dart';
import 'package:flutfest/widgets/buttons/primary_button.dart';
import 'package:flutfest/widgets/fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = AppTheme.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: IntroBackground(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final width = constraints.maxWidth;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.1,
                  vertical: width * 0.4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: width * 0.9,
                      fit: BoxFit.contain,
                    ),
                    const Gutter(),
                    Text(
                      'Login to FlutFest',
                  textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const Gutter(),
                    CustomTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                    ),
                    const Gutter(),
                    CustomTextField(
                      obscureText: true,
                      label: 'Password',
                      hint: 'Enter your password',
                    ),
                    const Gutter(),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.forgotPassword);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppTheme.darkLinkColor),
                      ),
                    ),
                    const Gutter(),
                    SizedBox(
                      width: width * 0.8,
                      child: PrimaryButton(
                        onPressed: () {
                          Get.toNamed(Routes.home);
                          showCustomSnackBar(
                            "UI navigation only. Implement your login logic.",
                          );
                        },
                        text: 'Login',
                      ),
                    ),
                    const Gutter(),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'or',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),
                    const Gutter(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: width * 0.8,
                          child: PrimaryButton(
                            icon: SvgPicture.asset(
                              'assets/icons/social_media/google-logo.svg',
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            backgroundColor: Colors.blue,
                            text: 'Login with Google',
                            onPressed: () {
                              showCustomSnackBar(
                                'Navigating to Google Login',
                              );
                            },
                          ),
                        ),
                        Gutter(),
                        SizedBox(
                          width: width * 0.8,
                          child: PrimaryButton(
                            textColor: isDark ? Colors.black : Colors.white,
                            icon: SvgPicture.asset(
                              'assets/icons/social_media/apple-logo.svg',
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                isDark ? Colors.black : Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            backgroundColor:
                                isDark ? Colors.white : Colors.black,
                            text: 'Login with Apple',
                            onPressed: () {
                              showCustomSnackBar(
                                'Navigating to Apple Login',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const Gutter(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don’t have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.register);
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: AppTheme.lightLinkColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
