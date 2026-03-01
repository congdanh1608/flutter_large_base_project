import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A reactive single-select dropdown using [DropdownButton2].
///
/// [T] is the value type stored in the [FormControl].
///
/// Usage:
/// ```dart
/// CustomReactiveSingleSelectDropdown<String>(
///   formControlName: 'country',
///   label: 'Country',
///   items: ['Vietnam', 'Singapore', 'USA'],
/// )
/// ```
class CustomReactiveSingleSelectDropdown<T>
    extends ReactiveFormField<T, T> {
  CustomReactiveSingleSelectDropdown({
    super.key,
    required super.formControlName,
    required String label,
    required List<T> items,
    String? hint,
    Widget Function(T item)? itemBuilder,
    super.validationMessages,
  }) : super(
          builder: (field) {
            Widget buildLabel(T item) =>
                itemBuilder != null ? itemBuilder(item) : Text(item.toString());

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField2<T>(
                  value: field.value,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: hint,
                    errorText:
                        field.errorText,
                  ),
                  items: items
                      .map(
                        (item) => DropdownMenuItem<T>(
                          value: item,
                          child: buildLabel(item),
                        ),
                      )
                      .toList(),
                  onChanged: field.control.enabled
                      ? (v) => field.didChange(v)
                      : null,
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    maxHeight: 280,
                  ),
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ),
              ],
            );
          },
        );
}
