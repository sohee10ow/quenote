import 'package:flutter/material.dart';

import '../../../features/sequence/domain/enums/side_type.dart';

class SideTypeSelector extends StatelessWidget {
  const SideTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final SideType value;
  final ValueChanged<SideType?> onChanged;

  static const _labels = <SideType, String>{
    SideType.none: '없음',
    SideType.left: '왼쪽',
    SideType.right: '오른쪽',
    SideType.both: '양쪽',
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<SideType>(
      initialValue: value,
      decoration: const InputDecoration(labelText: '사이드'),
      items: SideType.values
          .map(
            (type) =>
                DropdownMenuItem(value: type, child: Text(_labels[type]!)),
          )
          .toList(growable: false),
      onChanged: onChanged,
    );
  }
}
