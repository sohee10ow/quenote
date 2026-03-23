import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/components/buttons/primary_button.dart';
import '../../application/sequence_providers.dart';
import '../../domain/entities/sequence_step.dart';

class StepReorderScreen extends ConsumerStatefulWidget {
  const StepReorderScreen({super.key, required this.sequenceId});

  final int sequenceId;

  @override
  ConsumerState<StepReorderScreen> createState() => _StepReorderScreenState();
}

class _StepReorderScreenState extends ConsumerState<StepReorderScreen> {
  List<SequenceStep>? _steps;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final stepsAsync = ref.watch(sequenceStepsProvider(widget.sequenceId));

    return Scaffold(
      appBar: AppBar(title: const Text('동작 순서 변경')),
      body: stepsAsync.when(
        data: (loaded) {
          _steps ??= loaded;
          final steps = _steps!;

          if (steps.isEmpty) {
            return const Center(child: Text('정렬할 동작이 없습니다.'));
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            itemCount: steps.length,
            onReorder: _onReorder,
            itemBuilder: (context, index) {
              final step = steps[index];
              return Card(
                key: ValueKey(step.id),
                child: ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(step.poseName),
                  trailing: const Icon(Icons.drag_handle),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text('불러오기에 실패했습니다.')),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: PrimaryButton(
          label: _saving ? '저장 중...' : '순서 저장',
          onPressed: _saving || _steps == null ? null : _saveOrder,
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (_steps == null) {
      return;
    }

    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _steps!.removeAt(oldIndex);
      _steps!.insert(newIndex, item);
    });

    HapticFeedback.lightImpact();
  }

  Future<void> _saveOrder() async {
    if (_steps == null) {
      return;
    }

    setState(() => _saving = true);

    try {
      await ref
          .read(sequenceRepositoryProvider)
          .reorderSteps(
            sequenceId: widget.sequenceId,
            orderedStepIds: _steps!
                .map((step) => step.id)
                .toList(growable: false),
          );
      ref.invalidate(sequenceStepsProvider(widget.sequenceId));
      ref.invalidate(sequenceByIdProvider(widget.sequenceId));
      ref.invalidate(sequenceListProvider);
      ref.invalidate(recentSequenceListProvider);

      if (mounted) {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFE89D91),
            content: Text('저장에 실패했습니다. 다시 시도해주세요.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}
