import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A reactive searchable single-select dropdown using [DropdownButton2].
///
/// Injects a search text field at the top of the dropdown list.
/// The [FormControl] must hold a value of type [T].
///
/// Usage:
/// ```dart
/// CustomReactiveSearchableDropdown<String>(
///   formControlName: 'city',
///   label: 'City',
///   items: cities,
/// )
/// ```
class CustomReactiveSearchableDropdown<T>
    extends ReactiveFormField<T, T> {
  CustomReactiveSearchableDropdown({
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
            final searchController = TextEditingController();

            return DropdownButtonFormField2<T>(
              value: field.value,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                errorText: field.errorText,
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(label2(item)),
                    ),
                  )
                  .toList(),
              onChanged: field.control.enabled
                  ? (v) => field.didChange(v)
                  : null,
              dropdownSearchData: DropdownSearchData<T>(
                searchController: searchController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: TextFormField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, query) => label2(item.value as T)
                    .toLowerCase()
                    .contains(query.toLowerCase()),
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) searchController.clear();
              },
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                maxHeight: 320,
              ),
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down_rounded),
              ),
            );
          },
        );
}
