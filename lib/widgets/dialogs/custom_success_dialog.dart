import 'package:flutter/material.dart';
import 'package:flutfest/theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark
          ? AppTheme.darkBackgroundColor
          : AppTheme.lightBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: isDark
              ? AppTheme.darkTextColor
              : AppTheme.lightTextColor,
        ),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDark
              ? AppTheme.darkTextColor
              : AppTheme.lightTextColor,
        ),
      ),
      actions: actions,
    );
  }
}