import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../home/application/home_providers.dart';
import '../../application/sequence_providers.dart';
import '../../domain/enums/sequence_level.dart';
import '../args/sequence_route_args.dart';
import '../widgets/sequence_editor_field.dart';

class SequenceEditorScreen extends ConsumerStatefulWidget {
  const SequenceEditorScreen({super.key});

  @override
  ConsumerState<SequenceEditorScreen> createState() =>
      _SequenceEditorScreenState();
}

class _SequenceEditorScreenState extends ConsumerState<SequenceEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  bool _isSubmitting = false;
  bool _showLiveValidation = false;

  bool get _canSave =>
      !_isSubmitting && _titleController.text.trim().isNotEmpty;

  bool get _isDirty =>
      _titleController.text.trim().isNotEmpty ||
      _noteController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onInputChanged);
    _noteController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _titleController
      ..removeListener(_onInputChanged)
      ..dispose();
    _noteController
      ..removeListener(_onInputChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldPop = await _onBackAttempt();
        if (shouldPop && mounted) {
          Navigator.of(this.context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: DecoratedBox(
            decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _PressableScale(
                            child: _HeaderCircleButton(
                              key: const Key('sequenceEditorBackButton'),
                              icon: CupertinoIcons.back,
                              onTap: _isSubmitting ? null : _handleBackPressed,
                            ),
                          ),
                          const Spacer(),
                          _PressableScale(
                            child: _HeaderSaveButton(
                              key: const Key('sequenceEditorSaveButton'),
                              enabled: _canSave,
                              isLoading: _isSubmitting,
                              onTap: _onSave,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        '새 시퀀스',
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 24,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _showLiveValidation
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        24,
                        24,
                        24,
                        32 + MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SequenceEditorField(
                            label: '시퀀스 이름',
                            hintText: '예: 아침 활력 요가',
                            controller: _titleController,
                            maxLength: 30,
                            autofocus: true,
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty) {
                                return '시퀀스 이름을 입력해주세요.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          SequenceEditorField(
                            label: '수업 노트',
                            hintText: '수업 전체에 대한 메모를 작성하세요',
                            controller: _noteController,
                            maxLength: 300,
                            minLines: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onInputChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _handleBackPressed() async {
    final shouldPop = await _onBackAttempt();
    if (shouldPop && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _onBackAttempt() async {
    if (_isSubmitting) {
      return false;
    }
    if (!_isDirty) {
      return true;
    }

    final shouldDiscard = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('작성 중인 내용을 닫을까요?'),
          content: const Text('저장하지 않은 변경사항이 있습니다. 나가시겠어요?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('취소'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('나가기'),
            ),
          ],
        );
      },
    );

    return shouldDiscard ?? false;
  }

  Future<void> _onSave() async {
    if (!_canSave) {
      return;
    }

    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() => _showLiveValidation = true);
      return;
    }

    setState(() => _isSubmitting = true);

    final repository = ref.read(sequenceRepositoryProvider);
    try {
      HapticFeedback.lightImpact();
      final sequenceId = await repository.createSequence(
        title: _titleController.text.trim(),
        description: _noteController.text.trim(),
        level: SequenceLevel.beginner,
      );

      ref.invalidate(sequenceListProvider);
      ref.invalidate(recentSequenceListProvider);
      ref.invalidate(favoriteSequenceListProvider);
      ref.invalidate(homeOverviewProvider);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(
        AppRoutes.sequenceDetail,
        arguments: SequenceDetailRouteArgs(sequenceId: sequenceId),
      );
      return;
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFE89D91),
          content: Text('저장에 실패했습니다. 다시 시도해주세요.'),
        ),
      );
      setState(() => _isSubmitting = false);
      return;
    }
  }
}

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        onTap: onTap,
        child: SizedBox(width: 40, height: 40, child: Icon(icon, size: 18)),
      ),
    );
  }
}

class _HeaderSaveButton extends StatelessWidget {
  const _HeaderSaveButton({
    super.key,
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });

  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final backgroundColor = enabled ? primary : primary.withValues(alpha: 0.4);
    final foregroundColor = enabled
        ? Colors.white
        : Colors.white.withValues(alpha: 0.95);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: enabled && !isLoading ? onTap : null,
        borderRadius: BorderRadius.circular(999),
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.check_mark, size: 16, color: foregroundColor),
              const SizedBox(width: AppSpacing.xs),
              Text(
                isLoading ? '저장 중' : '저장',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 15,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PressableScale extends StatefulWidget {
  const _PressableScale({required this.child});

  final Widget child;

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
