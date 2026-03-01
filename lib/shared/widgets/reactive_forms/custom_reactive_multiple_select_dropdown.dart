import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A reactive multi-select dropdown using [DropdownButton2].
///
/// The [FormControl] must be of type `List<T>`.
/// Keeps a dropdown open on selection with checkboxes for each item.
///
/// Usage:
/// ```dart
/// CustomReactiveMultiSelectDropdown<String>(
///   formControlName: 'skills',
///   label: 'Skills',
///   items: ['Flutter', 'Dart', 'Kotlin', 'Swift'],
/// )
/// ```
class CustomReactiveMultiSelectDropdown<T>
    extends ReactiveFormField<List<T>, List<T>> {
  CustomReactiveMultiSelectDropdown({
    super.key,
    required super.formControlName,
    required String label,
    required List<T> items,
    String? hint,
    String Function(T item)? itemLabel,
    super.validationMessages,
  }) : super(
          builder: (field) {
            final label2 = itemLabel ?? (item) => item.toString();
            final selected = field.value ?? <T>[];

            final displayText = selected.isEmpty
                ? hint ?? 'Select...'
                : selected.map(label2).join(', ');

            return DropdownButtonHideUnderline(
              child: DropdownButton2<T>(
                isExpanded: true,
                hint: Text(
                  displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected.isEmpty
                        ? Theme.of(field.context)
                            .hintColor
                        : null,
                  ),
                ),
                items: items.map((item) {
                  final isSelected = selected.contains(item);
                  return DropdownMenuItem<T>(
                    value: item,
                    child: StatefulBuilder(
                      builder: (ctx, setItemState) {
                        return Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              onChanged: (_) {
                                final next = List<T>.from(selected);
                                if (isSelected) {
                                  next.remove(item);
                                } else {
                                  next.add(item);
                                }
                                field.didChange(next);
                              },
                            ),
                            const SizedBox(width: 4),
                            Expanded(child: Text(label2(item))),
                          ],
                        );
                      },
                    ),
                  );
                }).toList(),
                onChanged: field.control.enabled ? (_) {} : null,
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: field.errorText != null
                          ? Theme.of(field.context).colorScheme.error
                          : Theme.of(field.context).dividerColor,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 52,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  maxHeight: 300,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ),
            );
          },
        );
}
