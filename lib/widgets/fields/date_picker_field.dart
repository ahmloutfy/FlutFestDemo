import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final VoidCallback onTap;
  final FormFieldValidator<DateTimeRange?>? validator;

  const DatePickerField({
    super.key,
    required this.selectedRange,
    required this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<DateTimeRange?>(
      validator: validator,
      builder: (field) {
        return InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date Range',
              errorText: field.errorText,
            ),
            child: Text(
              selectedRange != null
                  ? '${DateFormat.yMMMMd().format(selectedRange!.start)}'
                  ' - ${DateFormat.yMMMMd().format(selectedRange!.end)}'
                  : 'Select a date range',
            ),
          ),
        );
      },
    );
  }
}