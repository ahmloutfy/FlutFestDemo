import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:flutfest/routes.dart';
import 'package:flutfest/theme.dart';
import 'package:flutfest/widgets/fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../widgets/backgrounds/intro_background.dart';
import '../../widgets/buttons/primary_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: IntroBackground(
          child: LayoutBuilder(
            builder: (context, constraints) {
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
                      'Create an Account',
                  textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const Gutter(),
                    CustomTextField(
                      label: 'Full Name',
                      hint: 'Enter your name',
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
                      hint: 'Create a password',
                    ),
                    const Gutter(),
                    CustomTextField(
                      obscureText: true,
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
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
                        text: 'Register',
                      ),
                    ),
                    const Gutter(),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'or',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const Gutter(),
                    SizedBox(
                      width: width * 0.8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          showCustomSnackBar('Register with Google');
                        },
                        child: Row(
                          children: [
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/icons/social_media/google-logo.svg',
                              height: 20,
                              width: 20,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            const Gutter(),
                            const Text('Register with Google'),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                    const Gutter(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.login);
                          },
                          child: Text(
                            'Login',
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
