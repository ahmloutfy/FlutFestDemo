import 'package:flutter/material.dart';

class DialogActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const DialogActionButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        onPressed();
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}