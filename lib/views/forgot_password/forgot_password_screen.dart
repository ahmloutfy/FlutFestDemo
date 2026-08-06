import 'package:flutfest/widgets/fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutfest/core/helpers/snackbar_helper.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isTablet = Get.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 500 : double.infinity,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_reset_rounded,
                  size: 80,
                  color: Get.theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Reset your password',
                  style: Get.textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter your email and we’ll send a reset link.',
                  style: Get.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  label: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('Send Reset Link'),
                    onPressed: () {
                      final email = emailController.text.trim();
                      if (email.isEmpty || !email.contains('@')) {
                        showCustomSnackBar('Please enter a valid email');
                      } else {
                        showCustomSnackBar('Reset link sent to $email');
                        Get.back();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
