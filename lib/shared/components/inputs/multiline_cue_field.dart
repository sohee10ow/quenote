import 'package:flutter/material.dart';

class MultilineCueField extends StatelessWidget {
  const MultilineCueField({
    super.key,
    required this.label,
    this.controller,
    this.maxLength,
  });

  final String label;
  final TextEditingController? controller;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(labelText: label, alignLabelWithHint: true),
    );
  }
}
