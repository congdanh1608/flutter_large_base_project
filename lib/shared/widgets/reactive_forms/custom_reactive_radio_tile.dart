import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A reactive radio tile for a single value choice.
///
/// Usage:
/// ```dart
/// CustomReactiveRadioTile<String>(
///   formControlName: 'gender',
///   value: 'male',
///   title: const Text('Male'),
/// )
/// ```
class CustomReactiveRadioTile<T> extends ReactiveFormField<T, T> {
  CustomReactiveRadioTile({
    super.key,
    required super.formControlName,
    required T value,
    required Widget title,
    Widget? subtitle,
    Widget? secondary,
    ListTileControlAffinity controlAffinity =
        ListTileControlAffinity.platform,
    super.validationMessages,
  }) : super(
          builder: (field) {
            final isSelected = field.value == value;

            void onTap() {
              if (field.control.enabled) field.didChange(value);
            }

            return ListTile(
              onTap: onTap,
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? null // uses theme primary
                    : null,
              ),
              title: title,
              subtitle: subtitle,
              trailing: secondary,
              contentPadding: EdgeInsets.zero,
            );
          },
        );
}
