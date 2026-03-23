import 'package:flutter/material.dart';

class BalanceToggle extends StatelessWidget {
  const BalanceToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('균형 동작'),
      value: value,
      onChanged: onChanged,
    );
  }
}
