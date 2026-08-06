import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutfest/core/helpers/snackbar_helper.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _launchEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@flutfest.com',
      query: Uri.encodeFull(
          'subject=Support Request&body=Hi, I need help with...'),
    );

    final bool success = await launchUrl(emailUri);

    if (!success) {
      showCustomSnackBar(
        'Could not open email app. Please send an email to support@flutfest.com manually.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.support_agent, size: 80),
            const SizedBox(height: 24),
            Text(
              'Need help?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'We’re here to help. Tap the button below to send us an email and we’ll get back to you as soon as possible.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _launchEmail(context),
              icon: const Icon(Icons.email_outlined),
              label: const Text('Contact Support'),
            ),
          ],
        ),
      ),
    );
  }
}
