import 'package:flutter/material.dart';

class MinimalTextField extends StatelessWidget {
  const MinimalTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.maxLength,
  });

  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLength: maxLength,
      buildCounter:
          (context, {required currentLength, required isFocused, maxLength}) {
            if (maxLength == null) {
              return null;
            }
            if (currentLength < (maxLength * 0.8).ceil()) {
              return null;
            }
            return Text('$currentLength/$maxLength');
          },
      decoration: InputDecoration(labelText: label),
    );
  }
}
