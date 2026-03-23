import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../home/application/home_providers.dart';
import '../../sequence/application/sequence_providers.dart';
import '../../sequence/domain/entities/sequence.dart';
import '../../sequence/presentation/args/sequence_route_args.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteSequenceListProvider);
    final stepCountsAsync = ref.watch(sequenceStepCountsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (favoritesAsync.hasError || stepCountsAsync.hasError) {
              return _FavoritesErrorView(
                onRetry: () {
                  ref.invalidate(favoriteSequenceListProvider);
                  ref.invalidate(sequenceStepCountsProvider);
                },
              );
            }

            final favorites = favoritesAsync.valueOrNull;
            final stepCounts = stepCountsAsync.valueOrNull;

            if (favorites == null || stepCounts == null) {
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

            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              children: [
                _FavoritesHeader(count: favorites.length),
                const SizedBox(height: 24),
                if (favorites.isEmpty)
                  const _FavoritesEmptyState()
                else
                  Column(
                    children: List<Widget>.generate(favorites.length, (index) {
                      final sequence = favorites[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == favorites.length - 1
                              ? 0
                              : AppSpacing.sm,
                        ),
                        child: _FavoriteSequenceCard(
                          sequence: sequence,
                          stepCount: stepCounts[sequence.id] ?? 0,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.sequenceDetail,
                              arguments: SequenceDetailRouteArgs(
                                sequenceId: sequence.id,
                              ),
                            );
                          },
                          onToggleFavorite: () =>
                              _toggleFavorite(context, ref, sequence.id),
                        ),
                      );
                    }),
                  ),
              ],
            );
          },
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
      ref.invalidate(sequenceListProvider);
      ref.invalidate(favoriteSequenceListProvider);
      ref.invalidate(recentSequenceListProvider);
      ref.invalidate(homeOverviewProvider);
      HapticFeedback.lightImpact();
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

class _FavoritesHeader extends StatelessWidget {
  const _FavoritesHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.favorite_rounded, size: 24, color: primary),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                '즐겨찾기',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$count개의 즐겨찾기',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

class _FavoriteSequenceCard extends StatelessWidget {
  const _FavoriteSequenceCard({
    required this.sequence,
    required this.stepCount,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Sequence sequence;
  final int stepCount;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
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
                      sequence.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$stepCount개 동작 • ${_formatMonthDay(sequence.updatedAt)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.88,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Material(
                color: primary.withValues(alpha: 0.1),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onToggleFavorite,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 18,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMonthDay(DateTime date) => '${date.month}월 ${date.day}일';
}

class _FavoritesEmptyState extends StatelessWidget {
  const _FavoritesEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.favorite_border_rounded,
              size: 40,
              color: primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            '아직 즐겨찾기한 시퀀스가 없어요\n자주 사용하는 시퀀스를 추가해보세요',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 15,
              height: 1.7,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesErrorView extends StatelessWidget {
  const _FavoritesErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('즐겨찾기를 불러오지 못했습니다.', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text('잠시 후 다시 시도해주세요.', style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
