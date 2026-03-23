import 'package:flutter/material.dart';

class SharePreviewSheet extends StatelessWidget {
  const SharePreviewSheet({
    super.key,
    required this.controller,
    required this.onCopy,
    required this.onShare,
  });

  final TextEditingController controller;
  final VoidCallback onCopy;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              maxLines: 12,
              decoration: const InputDecoration(labelText: '공유 미리보기'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCopy,
                    child: const Text('복사'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: onShare,
                    child: const Text('공유'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
