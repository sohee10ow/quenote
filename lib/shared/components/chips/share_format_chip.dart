import 'package:flutter/material.dart';

import '../../../features/settings/domain/enums/share_format_type.dart';

class ShareFormatChip extends StatelessWidget {
  const ShareFormatChip({
    super.key,
    required this.format,
    required this.selected,
    required this.onTap,
  });

  final ShareFormatType format;
  final bool selected;
  final VoidCallback onTap;

  static const _labels = <ShareFormatType, String>{
    ShareFormatType.full: '전체',
    ShareFormatType.cues: '큐잉',
    ShareFormatType.short: '짧게',
  };

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(_labels[format]!),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
