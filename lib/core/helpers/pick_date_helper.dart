import 'package:flutfest/theme.dart';
import 'package:flutter/material.dart';

class PickDateHelper {
  static Future<DateTimeRange?> showRange(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 1)),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: isDark ? AppTheme.darkButtonColor : AppTheme.lightButtonColor,
            ),
            datePickerTheme: DatePickerThemeData(
              rangeSelectionBackgroundColor: isDark
                  ? AppTheme.darkButtonColor.withValues(alpha: 0.3)
                  : AppTheme.lightButtonColor.withValues(alpha: 0.3),
              rangeSelectionOverlayColor: WidgetStateProperty.all(
                isDark
                    ? AppTheme.darkButtonColor.withValues(alpha: 0.15)
                    : AppTheme.lightButtonColor.withValues(alpha: 0.15),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

  }
}
