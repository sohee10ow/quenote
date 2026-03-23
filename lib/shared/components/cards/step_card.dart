import 'package:flutter/material.dart';

class StepCard extends StatelessWidget {
  const StepCard({
    super.key,
    required this.poseName,
    required this.preview,
    this.sideLabel = '',
    this.isBalancePose = false,
    this.onTap,
  });

  final String poseName;
  final String preview;
  final String sideLabel;
  final bool isBalancePose;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(poseName)),
                if (isBalancePose) const Chip(label: Text('균형')),
              ],
            ),
            if (sideLabel.isNotEmpty)
              Text(sideLabel, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        subtitle: Text(preview, maxLines: 3, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
