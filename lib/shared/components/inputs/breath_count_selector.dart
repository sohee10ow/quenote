import 'package:flutter/material.dart';

class BreathCountSelector extends StatelessWidget {
  const BreathCountSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: const InputDecoration(labelText: '호흡 수'),
      items: List<DropdownMenuItem<int>>.generate(
        10,
        (index) =>
            DropdownMenuItem(value: index + 1, child: Text('${index + 1}')),
      ),
      onChanged: onChanged,
    );
  }
}
