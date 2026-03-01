import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Reactive date picker field — taps open the system date picker.
///
/// Generic over [T] which must be [DateTime] or [DateTime?].
/// The [formControlName] control must be of type `DateTime?`.
class CustomReactiveDatePicker extends StatelessWidget {
  const CustomReactiveDatePicker({
    super.key,
    required this.formControlName,
    required this.label,
    this.hint,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.prefixIcon,
    this.validationMessages,
  });

  final String formControlName;
  final String label;
  final String? hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat? dateFormat;
  final IconData? prefixIcon;
  final Map<String, String Function(Object)>? validationMessages;

  @override
  Widget build(BuildContext context) {
    final fmt = dateFormat ?? DateFormat('dd/MM/yyyy');
    return ReactiveDatePicker<DateTime>(
      formControlName: formControlName,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (ctx, picker, child) {
        return ReactiveTextField<DateTime>(
          formControlName: formControlName,
          readOnly: true,
          validationMessages: validationMessages ?? {},
          onTap: (_) => picker.showPicker(),
          valueAccessor: DateTimeValueAccessor(dateTimeFormat: fmt),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint ?? fmt.pattern,
            prefixIcon:
                Icon(prefixIcon ?? Icons.calendar_today_outlined),
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
        );
      },
    );
  }
}
