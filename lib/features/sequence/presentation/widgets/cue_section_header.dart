import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

class CueSectionHeader extends StatelessWidget {
  const CueSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
