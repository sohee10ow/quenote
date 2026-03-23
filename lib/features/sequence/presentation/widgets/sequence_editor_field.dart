import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

class SequenceEditorField extends StatefulWidget {
  const SequenceEditorField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.maxLength,
    this.validator,
    this.minLines = 1,
    this.textInputAction,
    this.autofocus = false,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final int maxLength;
  final FormFieldValidator<String>? validator;
  final int minLines;
  final TextInputAction? textInputAction;
  final bool autofocus;

  @override
  State<SequenceEditorField> createState() => _SequenceEditorFieldState();
}

class _SequenceEditorFieldState extends State<SequenceEditorField> {
  late final FocusNode _focusNode;

  bool get _isMultiline => widget.minLines > 1;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.52) ??
        theme.colorScheme.onSurface.withValues(alpha: 0.52);
    final borderColor = _focusNode.hasFocus
        ? theme.colorScheme.primary
        : Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            validator: widget.validator,
            autofocus: widget.autofocus,
            maxLength: widget.maxLength,
            buildCounter: _buildCounter,
            minLines: widget.minLines,
            maxLines: _isMultiline ? null : 1,
            keyboardType: _isMultiline
                ? TextInputType.multiline
                : TextInputType.text,
            textInputAction:
                widget.textInputAction ??
                (_isMultiline ? TextInputAction.newline : TextInputAction.next),
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color: hintColor,
              ),
              isCollapsed: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: _isMultiline ? 16 : 16,
              ),
              errorStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
            scrollPadding: const EdgeInsets.all(AppSpacing.xl),
          ),
        ),
      ],
    );
  }

  Widget? _buildCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    if (maxLength == null) {
      return null;
    }
    if (currentLength < (maxLength * 0.8).ceil()) {
      return null;
    }
    return Text('$currentLength/$maxLength');
  }
}
