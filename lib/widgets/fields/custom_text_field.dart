import 'package:flutter/material.dart';
import 'package:flutfest/theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final bool autofocus;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode(context);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      autofocus: autofocus,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(

          color: isDark
              ? AppTheme.darkFieldTextColor.withOpacity(0.7)
              : AppTheme.lightFieldTextColor.withOpacity(0.7),
        ),

        prefixIcon: prefixIcon != null
            ? IconTheme(
          data: IconThemeData(
            color: AppTheme.getColorForTheme(
              context: context,
              lightModeColor: AppTheme.lightPrefixIconColor,
              darkModeColor: AppTheme.darkPrefixIconColor,
            ),
          ),
          child: prefixIcon!,
        )
            : null,
        suffixIcon: suffixIcon,
      ),
      validator: validator,

    );
  }
}
