import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../pro/application/pro_access.dart';
import '../../sequence/application/sequence_providers.dart';
import '../../sequence/presentation/args/sequence_route_args.dart';
import '../application/home_providers.dart';
import '../domain/entities/home_overview.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(homeOverviewProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: overviewAsync.when(
          data: (overview) => _HomeContent(
            overview: overview,
            onOpenSequenceEditor: () => _openCreateScreen(context, ref),
            onOpenSequenceList: () {
              Navigator.of(context).pushNamed(AppRoutes.sequenceList);
            },
            onOpenSequenceDetail: (sequenceId) {
              Navigator.of(context).pushNamed(
                AppRoutes.sequenceDetail,
                arguments: SequenceDetailRouteArgs(sequenceId: sequenceId),
              );
            },
            onToggleFavorite: (sequenceId) =>
                _toggleFavorite(context, ref, sequenceId),
          ),
          loading: () => const _HomeLoadingView(),
          error: (error, stackTrace) => _HomeErrorView(
            onRetry: () => ref.invalidate(homeOverviewProvider),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(
    BuildContext context,
    WidgetRef ref,
    int sequenceId,
  ) async {
    final repository = ref.read(sequenceRepositoryProvider);

    try {
      await repository.toggleFavorite(sequenceId);
      ref.invalidate(homeOverviewProvider);
      ref.invalidate(sequenceListProvider);
      ref.invalidate(recentSequenceListProvider);
      ref.invalidate(favoriteSequenceListProvider);
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFE89D91),
          content: Text('저장에 실패했습니다. 다시 시도해주세요.'),
        ),
      );
    }
  }

  Future<void> _openCreateScreen(BuildContext context, WidgetRef ref) async {
    final allowed = await ref
        .read(proAccessGuardProvider)
        .ensureCanCreateSequence(context);
    if (!allowed || !context.mounted) {
      return;
    }

    Navigator.of(context).pushNamed(AppRoutes.sequenceEditor);
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.overview,
    required this.onOpenSequenceEditor,
    required this.onOpenSequenceList,
    required this.onOpenSequenceDetail,
    required this.onToggleFavorite,
  });

  final HomeOverview overview;
  final VoidCallback onOpenSequenceEditor;
  final VoidCallback onOpenSequenceList;
  final ValueChanged<int> onOpenSequenceDetail;
  final ValueChanged<int> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        _HeroCard(
          sequenceCount: overview.recentSequences.length,
          favoriteCount: overview.favoriteSequences.length,
          onOpenSequenceEditor: onOpenSequenceEditor,
          onOpenSequenceList: onOpenSequenceList,
        ),
        const SizedBox(height: AppSpacing.xxl),
        _RecentSequenceSection(
          sequences: overview.recentSequences,
          onOpenSequenceEditor: onOpenSequenceEditor,
          onOpenSequenceList: onOpenSequenceList,
          onOpenSequenceDetail: onOpenSequenceDetail,
          onToggleFavorite: onToggleFavorite,
        ),
        const SizedBox(height: AppSpacing.xxl),
        _RecentCueNoteSection(
          cueNotes: overview.recentCueNotes,
          onOpenSequenceDetail: onOpenSequenceDetail,
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.sequenceCount,
    required this.favoriteCount,
    required this.onOpenSequenceEditor,
    required this.onOpenSequenceList,
  });

  final int sequenceCount;
  final int favoriteCount;
  final VoidCallback onOpenSequenceEditor;
  final VoidCallback onOpenSequenceList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final deepTone = Color.lerp(primary, Colors.black, 0.18) ?? primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, deepTone],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned(
              top: -18,
              right: -12,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              right: 38,
              bottom: -34,
              child: Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '요가 큐 노트',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '시퀀스를 만들고\n큐를 쌓는 요가 노트',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 31,
                      height: 1.14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '수업 흐름을 시퀀스로 정리하고, 각 동작의 준비동작 큐잉과 호흡 큐잉, 동작 푸는 큐잉을 한 번에 쌓아보세요.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      height: 1.65,
                      color: Colors.white.withValues(alpha: 0.84),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _HeroStatChip(label: '최근 시퀀스', value: '$sequenceCount개'),
                      _HeroStatChip(label: '즐겨찾기', value: '$favoriteCount개'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: _HeroButton(
                          label: '새 시퀀스 시작',
                          onTap: onOpenSequenceEditor,
                          filled: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _HeroButton(
                          label: '전체 시퀀스 보기',
                          onTap: onOpenSequenceList,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStatChip extends StatelessWidget {
  const _HeroStatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ),
            TextSpan(
              text: value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = filled ? theme.colorScheme.primary : Colors.white;

    return Material(
      color: filled ? Colors.white : Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: filled
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentSequenceSection extends StatelessWidget {
  const _RecentSequenceSection({
    required this.sequences,
    required this.onOpenSequenceEditor,
    required this.onOpenSequenceList,
    required this.onOpenSequenceDetail,
    required this.onToggleFavorite,
  });

  final List<HomeSequenceSummary> sequences;
  final VoidCallback onOpenSequenceEditor;
  final VoidCallback onOpenSequenceList;
  final ValueChanged<int> onOpenSequenceDetail;
  final ValueChanged<int> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: '최근 시퀀스',
          description: '가장 최근에 정리한 수업안을 바로 이어서 수정할 수 있어요.',
          actionLabel: sequences.isEmpty ? null : '전체보기',
          onTap: sequences.isEmpty ? null : onOpenSequenceList,
        ),
        const SizedBox(height: AppSpacing.md),
        if (sequences.isEmpty)
          _SequenceJourneyCard(onTap: onOpenSequenceEditor)
        else
          Column(
            children: List<Widget>.generate(sequences.length, (index) {
              final summary = sequences[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == sequences.length - 1 ? 0 : AppSpacing.sm,
                ),
                child: _SequenceSummaryCard(
                  title: summary.sequence.title,
                  stepCount: summary.stepCount,
                  dateLabel: _buildMonthDay(summary.sequence.updatedAt),
                  onTap: () => onOpenSequenceDetail(summary.sequence.id),
                  trailing: summary.sequence.isFavorite
                      ? _FavoriteIconButton(
                          active: true,
                          onTap: () => onToggleFavorite(summary.sequence.id),
                        )
                      : _FavoriteIconButton(
                          active: false,
                          onTap: () => onToggleFavorite(summary.sequence.id),
                        ),
                ),
              );
            }),
          ),
      ],
    );
  }

  String _buildMonthDay(DateTime date) => '${date.month}월 ${date.day}일';
}

class _RecentCueNoteSection extends StatelessWidget {
  const _RecentCueNoteSection({
    required this.cueNotes,
    required this.onOpenSequenceDetail,
  });

  final List<HomeRecentCueNoteSummary> cueNotes;
  final ValueChanged<int> onOpenSequenceDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: '최근 편집한 큐 노트',
          description: '최근에 만진 동작을 시퀀스 맥락 안에서 다시 열 수 있어요.',
        ),
        const SizedBox(height: AppSpacing.md),
        if (cueNotes.isEmpty)
          const _SectionPlaceholderCard(
            icon: Icons.edit_note_rounded,
            title: '아직 최근 큐 노트가 없어요',
            body: '시퀀스에 동작을 추가하고 큐를 쓰기 시작하면 최근 작업이 여기에 쌓여요.',
          )
        else
          Column(
            children: List<Widget>.generate(cueNotes.length, (index) {
              final cueNote = cueNotes[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == cueNotes.length - 1 ? 0 : AppSpacing.xs,
                ),
                child: _RecentCueNoteCard(
                  cueNote: cueNote,
                  onTap: () => onOpenSequenceDetail(cueNote.sequenceId),
                ),
              );
            }),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.description,
    this.actionLabel,
    this.onTap,
  });

  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null) ...[
          const SizedBox(width: AppSpacing.md),
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                actionLabel!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SequenceJourneyCard extends StatelessWidget {
  const _SequenceJourneyCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '처음은 시퀀스부터 시작해요',
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 21),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '사용법을 외우지 않아도 되도록, 가장 자연스러운 흐름만 먼저 보여드릴게요.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _FlowStepRow(
            index: 1,
            title: '시퀀스 생성',
            description: '수업 이름과 메모를 먼저 만들어요.',
          ),
          const SizedBox(height: AppSpacing.md),
          const _FlowStepRow(
            index: 2,
            title: '동작 추가',
            description: '각 동작에 준비, 호흡, 마무리 큐를 쌓아요.',
          ),
          const SizedBox(height: AppSpacing.md),
          const _FlowStepRow(
            index: 3,
            title: '공유',
            description: '정리된 텍스트를 바로 복사하거나 공유해요.',
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: onTap,
              child: const Text('첫 시퀀스 만들기'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowStepRow extends StatelessWidget {
  const _FlowStepRow({
    required this.index,
    required this.title,
    required this.description,
  });

  final int index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primary.withValues(alpha: 0.12),
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionPlaceholderCard extends StatelessWidget {
  const _SectionPlaceholderCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SequenceSummaryCard extends StatelessWidget {
  const _SequenceSummaryCard({
    required this.title,
    required this.stepCount,
    required this.dateLabel,
    required this.onTap,
    this.trailing,
  });

  final String title;
  final int stepCount;
  final String dateLabel;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '$stepCount개 동작  •  $dateLabel',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _FavoriteIconButton extends StatelessWidget {
  const _FavoriteIconButton({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active
              ? primary.withValues(alpha: 0.12)
              : theme.scaffoldBackgroundColor,
        ),
        alignment: Alignment.center,
        child: Icon(
          active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 16,
          color: active
              ? primary
              : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.86),
        ),
      ),
    );
  }
}

class _RecentCueNoteCard extends StatelessWidget {
  const _RecentCueNoteCard({required this.cueNote, required this.onTap});

  final HomeRecentCueNoteSummary cueNote;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: primary.withValues(alpha: 0.12),
              ),
              alignment: Alignment.center,
              child: Text(
                '${cueNote.stepOrder}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cueNote.poseName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cueNote.sequenceTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                  if (cueNote.preview != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      cueNote.preview!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.9,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        Container(
          height: 290,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        ...List<Widget>.generate(2, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == 1 ? 0 : AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 180,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.cardColor.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.cardColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        _HeroCard(
          sequenceCount: 0,
          favoriteCount: 0,
          onOpenSequenceEditor: () {},
          onOpenSequenceList: () {},
        ),
        const SizedBox(height: AppSpacing.xxl),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '홈 화면을 불러오지 못했어요',
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text('잠시 후 다시 시도해주세요.', style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: onRetry,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  '다시 시도',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
