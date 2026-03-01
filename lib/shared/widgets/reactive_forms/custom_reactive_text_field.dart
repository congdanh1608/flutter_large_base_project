import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Styled ReactiveTextField with show/hide password support.
class CustomReactiveTextField<T> extends StatefulWidget {
  const CustomReactiveTextField({
    super.key,
    required this.formControlName,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.autofillHints,
    this.validationMessages,
    this.onSubmitted,
  });

  final String formControlName;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final Iterable<String>? autofillHints;
  final Map<String, String Function(Object)>? validationMessages;
  final void Function(FormControl<T>)? onSubmitted;

  @override
  State<CustomReactiveTextField<T>> createState() =>
      _CustomReactiveTextFieldState<T>();
}

class _CustomReactiveTextFieldState<T>
    extends State<CustomReactiveTextField<T>> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<T>(
      formControlName: widget.formControlName,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword && _obscure,
      autofillHints: widget.autofillHints,
      onSubmitted: widget.onSubmitted,
      validationMessages: widget.validationMessages ?? {},
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon:
            widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}
