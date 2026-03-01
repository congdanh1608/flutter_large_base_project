import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A reactive switch (toggle) bound to a `bool` FormControl.
///
/// Usage:
/// ```dart
/// CustomReactiveSwitch(
///   formControlName: 'receiveNotifications',
///   title: const Text('Receive notifications'),
/// )
/// ```
class CustomReactiveSwitch extends ReactiveFormField<bool, bool> {
  CustomReactiveSwitch({
    super.key,
    required super.formControlName,
    required Widget title,
    Widget? subtitle,
    Widget? secondary,
    ListTileControlAffinity controlAffinity =
        ListTileControlAffinity.platform,
    super.validationMessages,
  }) : super(
          builder: (field) {
            return SwitchListTile(
              value: field.value ?? false,
              title: title,
              subtitle: subtitle,
              secondary: secondary,
              controlAffinity: controlAffinity,
              onChanged: field.control.enabled
                  ? (v) => field.didChange(v)
                  : null,
            );
          },
        );
}
