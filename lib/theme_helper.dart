import 'package:flutter/material.dart';

class ThemeHelper {
  // Method to check the current brightness mode (light or dark)
  static Brightness getBrightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  // Method to get the background color based on the brightness mode
  static Color getBackgroundColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).scaffoldBackgroundColor;
  }

  // Method to get the text color based on the brightness mode
  static Color getTextColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).textTheme.bodyMedium!.color!;
  }

  // Method to get the border color based on the brightness mode
  static Color getBorderColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Colors.white30
        : Colors.black12;
  }

  // Method to get the button color based on the brightness mode
  static Color getButtonColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
  }

  // Method to get the background color for SnackBar based on the brightness mode
  static Color getSnackBarBackgroundColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).scaffoldBackgroundColor;
  }

  // Method to get the text color for SnackBar based on the brightness mode
  static Color getSnackBarTextColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).textTheme.bodyMedium!.color!;
  }

  // Method to get the background color for AppBar based on the brightness mode
  static Color getAppBarBackgroundColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).appBarTheme.backgroundColor!
        : Theme.of(context).primaryColor;
  }

  // Method to get the text color for AppBar based on the brightness mode
  static Color getAppBarTextColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).textTheme.titleLarge!.color!;
  }

  // Method to get the background color for Card based on the brightness mode
  static Color getCardBackgroundColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.surface;
  }

  // Method to get the color for dividers based on the brightness mode
  static Color getDividerColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).dividerColor
        : Colors.black12;
  }

  // Method to get the color for TextButton based on the brightness mode
  static Color getTextButtonColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
  }

  // Method to get the color for icons based on the brightness mode
  static Color getIconColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).iconTheme.color!
        : Theme.of(context).colorScheme.onSurface;
  }

  // Method to get the background color for InputFields based on the brightness mode
  static Color getInputFieldBackgroundColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).inputDecorationTheme.fillColor!
        : Theme.of(context).scaffoldBackgroundColor;
  }

  // Method to get the text color for InputFields based on the brightness mode
  static Color getInputFieldTextColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).inputDecorationTheme.labelStyle!.color!
        : Theme.of(context).textTheme.bodyMedium!.color!;
  }

  // Method to get the border color for InputFields based on the brightness mode
  static Color getInputFieldBorderColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).inputDecorationTheme.border!.borderSide.color
        : Theme.of(context).dividerColor;
  }

  // Method to get the text style for AppBar based on the brightness mode
  static TextStyle getAppBarTextStyle(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(color: getAppBarTextColor(context));
  }

  // Method to get the button style for ElevatedButton based on the brightness mode
  static ButtonStyle getElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: getTextColor(context),
      backgroundColor: getButtonColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Method to get the button style for TextButton based on the brightness mode
  static ButtonStyle getTextButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: getButtonColor(context),
      disabledForegroundColor: getTextColor(context).withValues(alpha: 0.38),
    );
  }

  // Method to get the button style for OutlinedButton based on the brightness mode
  static ButtonStyle getOutlinedButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: getButtonColor(context),
      side: BorderSide(color: getButtonColor(context)),
    );
  }

  // Method to get the background color for FloatingActionButton based on the brightness mode
  static Color getFloatingActionButtonColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(context).floatingActionButtonTheme.backgroundColor!
        : Theme.of(context).primaryColor;
  }

  // Method to get the color for Checkbox based on the brightness mode
  static Color? getCheckboxColor(BuildContext context) {
    return getBrightness(context) == Brightness.dark
        ? Theme.of(
          context,
        ).checkboxTheme.fillColor!.resolve({WidgetState.selected})
        : Theme.of(context).checkboxTheme.fillColor!.resolve({
          WidgetState.selected,
          WidgetState.disabled,
        });
  }

  // Method to get the IconTheme for icons based on the brightness mode
  static IconThemeData getIconTheme(BuildContext context) {
    return IconThemeData(color: getIconColor(context));
  }
}
