import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
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
            onOpenSequenceEditor: () {
              Navigator.of(context).pushNamed(AppRoutes.sequenceEditor);
            },
            onOpenSequenceList: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(AppRoutes.sequenceList);
            },
            onOpenSequenceDetail: (sequenceId) {
              Navigator.of(context).pushNamed(
                AppRoutes.sequenceDetail,
                arguments: SequenceDetailRouteArgs(sequenceId: sequenceId),
              );
            },
            onOpenStepEditor: (sequenceId, stepId) {
              Navigator.of(context).pushNamed(
                AppRoutes.stepEditor,
                arguments: StepEditorRouteArgs(
                  sequenceId: sequenceId,
                  stepId: stepId,
                ),
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
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.overview,
    required this.onOpenSequenceEditor,
    required this.onOpenSequenceList,
    required this.onOpenSequenceDetail,
    required this.onOpenStepEditor,
    required this.onToggleFavorite,
  });

  final HomeOverview overview;
  final VoidCallback onOpenSequenceEditor;
  final VoidCallback onOpenSequenceList;
  final ValueChanged<int> onOpenSequenceDetail;
  final void Function(int sequenceId, int stepId) onOpenStepEditor;
  final ValueChanged<int> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      if (overview.favoriteSequences.isNotEmpty)
        _FavoriteSection(
          sequences: overview.favoriteSequences,
          onOpenSequenceDetail: onOpenSequenceDetail,
          onToggleFavorite: onToggleFavorite,
        ),
      if (overview.recentSequences.isNotEmpty)
        _RecentSequenceSection(
          sequences: overview.recentSequences,
          onOpenSequenceList: onOpenSequenceList,
          onOpenSequenceDetail: onOpenSequenceDetail,
          onToggleFavorite: onToggleFavorite,
        ),
      if (overview.recentCueNotes.isNotEmpty)
        _RecentCueNoteSection(
          cueNotes: overview.recentCueNotes,
          onOpenStepEditor: onOpenStepEditor,
        ),
      if (!overview.hasSequences) const _HomeEmptyState(),
    ];

    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: _GreetingHeader(
            dateLabel: _buildDateLabel(),
            title: _greeting(),
          ),
        ),
        if (overview.hasSequences)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: _QuickCreateCard(onTap: onOpenSequenceEditor),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
          child: Column(
            children: List<Widget>.generate(sections.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == sections.length - 1 ? 0 : AppSpacing.xxl,
                ),
                child: sections[index],
              );
            }),
          ),
        ),
      ],
    );
  }

  String _buildDateLabel() {
    const weekdays = <String>['월', '화', '수', '목', '금', '토', '일'];
    final now = DateTime.now();
    return '${now.month}월 ${now.day}일 ${weekdays[now.weekday - 1]}';
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '좋은 아침이에요';
    }
    if (hour < 18) {
      return '좋은 오후에요';
    }
    return '좋은 저녁이에요';
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.dateLabel, required this.title});

  final String dateLabel;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.92,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 30,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primary.withValues(alpha: 0.22),
                primary.withValues(alpha: 0.1),
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.auto_awesome_rounded, size: 22, color: primary),
        ),
      ],
    );
  }
}

class _QuickCreateCard extends StatelessWidget {
  const _QuickCreateCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final endColor = Color.lerp(primary, Colors.black, 0.08) ?? primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primary, endColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.add_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '빠른 노트 작성',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '새로운 시퀀스 시작하기',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: Colors.white.withValues(alpha: 0.62),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteSection extends StatelessWidget {
  const _FavoriteSection({
    required this.sequences,
    required this.onOpenSequenceDetail,
    required this.onToggleFavorite,
  });

  final List<HomeSequenceSummary> sequences;
  final ValueChanged<int> onOpenSequenceDetail;
  final ValueChanged<int> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: '즐겨찾기',
          icon: Icons.favorite_rounded,
          actionLabel: '전체보기',
          onTap: () {},
        ),
        const SizedBox(height: AppSpacing.md),
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
                trailing: _FavoriteIconButton(
                  active: true,
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

class _RecentSequenceSection extends StatelessWidget {
  const _RecentSequenceSection({
    required this.sequences,
    required this.onOpenSequenceList,
    required this.onOpenSequenceDetail,
    required this.onToggleFavorite,
  });

  final List<HomeSequenceSummary> sequences;
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
          actionLabel: '전체보기',
          onTap: onOpenSequenceList,
        ),
        const SizedBox(height: AppSpacing.md),
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
                    ? null
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
    required this.onOpenStepEditor,
  });

  final List<HomeRecentCueNoteSummary> cueNotes;
  final void Function(int sequenceId, int stepId) onOpenStepEditor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: '최근 편집한 큐 노트', icon: Icons.edit_rounded),
        const SizedBox(height: AppSpacing.md),
        Column(
          children: List<Widget>.generate(cueNotes.length, (index) {
            final cueNote = cueNotes[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == cueNotes.length - 1 ? 0 : AppSpacing.xs,
              ),
              child: _RecentCueNoteCard(
                cueNote: cueNote,
                onTap: () =>
                    onOpenStepEditor(cueNote.sequenceId, cueNote.stepId),
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
    this.icon,
    this.actionLabel,
    this.onTap,
  });

  final String title;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: primary),
          const SizedBox(width: AppSpacing.xs),
        ],
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              child: Text(
                actionLabel!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: primary,
                ),
              ),
            ),
          ),
      ],
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
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 16),
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
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withValues(alpha: 0.1),
              ),
              alignment: Alignment.center,
              child: Text(
                '${cueNote.stepOrder}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: primary,
                  fontWeight: FontWeight.w600,
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
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
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
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeEmptyState extends StatelessWidget {
  const _HomeEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: 0.1),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.add_rounded, size: 44, color: primary),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            '시작해볼까요?',
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '첫 번째 시퀀스를 만들고\n큐잉 노트를 작성해보세요',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
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
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: _GreetingHeader(dateLabel: '불러오는 중', title: '좋은 하루에요'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
          child: _QuickCreateCard(onTap: () {}),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
          child: Column(
            children: List<Widget>.generate(3, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == 2 ? 0 : AppSpacing.sm,
                ),
                child: Container(
                  height: index == 2 ? 84 : 92,
                  decoration: BoxDecoration(
                    color: theme.cardColor.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
          ),
        ),
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

    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: _GreetingHeader(
            dateLabel: _buildDateLabel(),
            title: '좋은 하루에요',
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('홈 화면을 불러오지 못했어요', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text('잠시 후 다시 시도해주세요.', style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.md),
                GestureDetector(
                  onTap: onRetry,
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    '다시 시도',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _buildDateLabel() {
    const weekdays = <String>['월', '화', '수', '목', '금', '토', '일'];
    final now = DateTime.now();
    return '${now.month}월 ${now.day}일 ${weekdays[now.weekday - 1]}';
  }
}
