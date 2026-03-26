import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../home/application/home_providers.dart';
import '../../application/sequence_providers.dart';
import '../../domain/entities/sequence.dart';
import '../args/sequence_route_args.dart';

class StepDuplicateTargetScreen extends ConsumerStatefulWidget {
  const StepDuplicateTargetScreen({
    super.key,
    required this.sourceSequenceId,
    required this.sourceStepId,
  });

  final int sourceSequenceId;
  final int sourceStepId;

  @override
  ConsumerState<StepDuplicateTargetScreen> createState() =>
      _StepDuplicateTargetScreenState();
}

class _StepDuplicateTargetScreenState
    extends ConsumerState<StepDuplicateTargetScreen> {
  late final TextEditingController _searchController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_handleChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleChanged)
      ..dispose();
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final sequencesAsync = ref.watch(sequenceListProvider);
    final stepCountsAsync = ref.watch(sequenceStepCountsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (sequencesAsync.hasError || stepCountsAsync.hasError) {
              return const Center(child: Text('시퀀스를 불러오지 못했습니다.'));
            }

            final sequences = sequencesAsync.valueOrNull;
            final stepCounts = stepCountsAsync.valueOrNull;

            if (sequences == null || stepCounts == null) {
              return Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: theme.colorScheme.primary,
                  ),
                ),
              );
            }

            return _buildContent(context, sequences, stepCounts);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Sequence> sequences,
    Map<int, int> stepCounts,
  ) {
    final theme = Theme.of(context);
    final filtered = sequences
        .where((sequence) => sequence.id != widget.sourceSequenceId)
        .where((sequence) {
          final query = _searchController.text.trim().toLowerCase();
          if (query.isEmpty) {
            return true;
          }
          return sequence.title.toLowerCase().contains(query);
        })
        .toList(growable: false);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          decoration: BoxDecoration(
            color: theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CircleIconButton(
                    icon: CupertinoIcons.back,
                    onTap: _isSubmitting ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '다른 시퀀스에 넣기',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '복제할 시퀀스를 선택하면 맨 뒤에 동작이 추가됩니다.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SearchField(controller: _searchController),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? _EmptyState(hasQuery: _searchController.text.trim().isNotEmpty)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  itemBuilder: (context, index) {
                    final sequence = filtered[index];
                    return _SequenceTargetCard(
                      title: sequence.title,
                      description: sequence.description,
                      stepCount: stepCounts[sequence.id] ?? 0,
                      isSubmitting: _isSubmitting,
                      onTap: () => _duplicateToTarget(context, sequence.id),
                    );
                  },
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemCount: filtered.length,
                ),
        ),
      ],
    );
  }

  Future<void> _duplicateToTarget(BuildContext context, int targetSequenceId) async {
    if (_isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await ref
          .read(sequenceRepositoryProvider)
          .duplicateStepIntoSequence(
            stepId: widget.sourceStepId,
            targetSequenceId: targetSequenceId,
          );

      _invalidateCaches(result.targetSequenceId);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(
        AppRoutes.sequenceDetail,
        arguments: SequenceDetailRouteArgs(sequenceId: result.targetSequenceId),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFE89D91),
          content: Text('동작을 복제하지 못했습니다. 다시 시도해주세요.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _invalidateCaches(int targetSequenceId) {
    ref.invalidate(sequenceStepsProvider(widget.sourceSequenceId));
    ref.invalidate(sequenceByIdProvider(widget.sourceSequenceId));
    ref.invalidate(sequenceStepsProvider(targetSequenceId));
    ref.invalidate(sequenceByIdProvider(targetSequenceId));
    ref.invalidate(sequenceListProvider);
    ref.invalidate(sequenceStepCountsProvider);
    ref.invalidate(favoriteSequenceListProvider);
    ref.invalidate(recentSequenceListProvider);
    ref.invalidate(homeOverviewProvider);
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 18, color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
      decoration: InputDecoration(
        hintText: '시퀀스 검색',
        prefixIcon: const Icon(CupertinoIcons.search),
        filled: true,
        fillColor: theme.scaffoldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SequenceTargetCard extends StatelessWidget {
  const _SequenceTargetCard({
    required this.title,
    required this.description,
    required this.stepCount,
    required this.isSubmitting,
    required this.onTap,
  });

  final String title;
  final String? description;
  final int stepCount;
  final bool isSubmitting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSubmitting ? null : onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$stepCount',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if ((description ?? '').trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          description!.trim(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                CupertinoIcons.square_stack_3d_down_right,
                size: 28,
                color: primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasQuery ? '검색 결과가 없어요' : '선택할 다른 시퀀스가 없어요',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              hasQuery
                  ? '다른 검색어로 시퀀스를 찾아보세요.'
                  : '현재 시퀀스를 제외하면 복제할 대상이 아직 없습니다.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
