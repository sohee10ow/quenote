import 'package:flutter/material.dart';

class SequenceCard extends StatelessWidget {
  const SequenceCard({
    super.key,
    required this.title,
    this.description,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? description;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        subtitle: description == null || description!.isEmpty
            ? null
            : Text(description!, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: trailing,
      ),
    );
  }
}
