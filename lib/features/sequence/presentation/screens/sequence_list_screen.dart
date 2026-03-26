import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../home/application/home_providers.dart';
import '../../../pro/application/pro_access.dart';
import '../../application/sequence_providers.dart';
import '../../domain/entities/sequence.dart';
import '../args/sequence_route_args.dart';

class SequenceListScreen extends ConsumerStatefulWidget {
  const SequenceListScreen({super.key});

  @override
  ConsumerState<SequenceListScreen> createState() => _SequenceListScreenState();
}

class _SequenceListScreenState extends ConsumerState<SequenceListScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  _SequenceFilter _activeFilter = _SequenceFilter.all;
  _SequenceSort _sortBy = _SequenceSort.recent;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(_handleFieldChanged);
    _searchFocusNode = FocusNode()..addListener(_handleFieldChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleFieldChanged)
      ..dispose();
    _searchFocusNode
      ..removeListener(_handleFieldChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(sequenceListProvider);
    final stepCountsAsync = ref.watch(sequenceStepCountsProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: _dismissKeyboard,
          behavior: HitTestBehavior.opaque,
          child: Builder(
            builder: (context) {
              final sequences = listAsync.valueOrNull;
              final stepCounts = stepCountsAsync.valueOrNull;

              if (listAsync.hasError || stepCountsAsync.hasError) {
                return _SequenceListErrorView(onRetry: _refresh);
              }

              if (sequences == null || stepCounts == null) {
                return Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: primary,
                    ),
                  ),
                );
              }

              return _buildContent(context, sequences, stepCounts);
            },
          ),
        ),
      ),
      floatingActionButton: _FloatingCreateButton(
        onTap: () => _openCreateScreen(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Sequence> sequences,
    Map<int, int> stepCounts,
  ) {
    final items = sequences
        .map(
          (sequence) => _SequenceListItem(
            sequence: sequence,
            stepCount: stepCounts[sequence.id] ?? 0,
          ),
        )
        .toList(growable: false);
    final filteredItems = _buildFilteredItems(items);

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 132),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: _SequenceHeader(count: filteredItems.length),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: _SequenceSearchField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onClear: () => _searchController.clear(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: _FilterChipRow(
            activeFilter: _activeFilter,
            onChanged: (filter) => setState(() => _activeFilter = filter),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: _SortRow(
            currentSortLabel: _sortBy.label,
            onTap: (buttonContext) => _openSortMenu(buttonContext),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: filteredItems.isEmpty
              ? _SequenceEmptyState(
                  isSearchResult:
                      _searchController.text.trim().isNotEmpty ||
                      _activeFilter != _SequenceFilter.all,
                )
              : Column(
                  children: List<Widget>.generate(filteredItems.length, (
                    index,
                  ) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == filteredItems.length - 1
                            ? 0
                            : AppSpacing.xs,
                      ),
                      child: _SequenceListCard(
                        item: filteredItems[index],
                        onTap: () => _openDetail(context, filteredItems[index]),
                        onToggleFavorite: () => _toggleFavorite(
                          context,
                          filteredItems[index].sequence.id,
                        ),
                      ),
                    );
                  }),
                ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Future<void> _openCreateScreen(BuildContext context) async {
    final allowed = await ref
        .read(proAccessGuardProvider)
        .ensureCanCreateSequence(context);
    if (!allowed || !context.mounted) {
      return;
    }
    Navigator.of(context).pushNamed(AppRoutes.sequenceEditor);
  }

  void _openDetail(BuildContext context, _SequenceListItem item) {
    Navigator.of(context).pushNamed(
      AppRoutes.sequenceDetail,
      arguments: SequenceDetailRouteArgs(sequenceId: item.sequence.id),
    );
  }

  void _handleFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _refresh() {
    ref.invalidate(sequenceListProvider);
    ref.invalidate(sequenceStepCountsProvider);
  }

  Future<void> _openSortMenu(BuildContext buttonContext) async {
    _dismissKeyboard();
    final button = buttonContext.findRenderObject() as RenderBox?;
    final overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;

    if (button == null || overlay == null) {
      return;
    }

    final topLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
    final bottomRight = button.localToGlobal(
      button.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );

    final selected = await showMenu<_SequenceSort>(
      context: context,
      color: Theme.of(context).cardColor,
      elevation: 0,
      position: RelativeRect.fromRect(
        Rect.fromPoints(topLeft, bottomRight),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      items: _SequenceSort.values
          .map((sort) {
            final isSelected = sort == _sortBy;
            return PopupMenuItem<_SequenceSort>(
              value: sort,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                sort.label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            );
          })
          .toList(growable: false),
    );

    if (selected != null && mounted) {
      setState(() => _sortBy = selected);
    }
  }

  List<_SequenceListItem> _buildFilteredItems(List<_SequenceListItem> items) {
    final query = _searchController.text.trim().toLowerCase();
    var filtered = items.where((item) {
      if (query.isEmpty) {
        return true;
      }
      return item.sequence.title.toLowerCase().contains(query);
    }).toList();

    final recentThreshold = DateTime.now().subtract(const Duration(days: 7));

    filtered = filtered.where((item) {
      switch (_activeFilter) {
        case _SequenceFilter.all:
          return true;
        case _SequenceFilter.favorites:
          return item.sequence.isFavorite;
        case _SequenceFilter.recent:
          return !item.sequence.updatedAt.isBefore(recentThreshold);
        case _SequenceFilter.short:
          return item.stepCount <= 5;
        case _SequenceFilter.long:
          return item.stepCount > 10;
      }
    }).toList();

    filtered.sort((a, b) {
      switch (_sortBy) {
        case _SequenceSort.recent:
          return b.sequence.updatedAt.compareTo(a.sequence.updatedAt);
        case _SequenceSort.name:
          return a.sequence.title.toLowerCase().compareTo(
            b.sequence.title.toLowerCase(),
          );
        case _SequenceSort.stepsAscending:
          return a.stepCount.compareTo(b.stepCount);
        case _SequenceSort.stepsDescending:
          return b.stepCount.compareTo(a.stepCount);
      }
    });

    return filtered;
  }

  Future<void> _toggleFavorite(BuildContext context, int sequenceId) async {
    final repository = ref.read(sequenceRepositoryProvider);

    try {
      await repository.toggleFavorite(sequenceId);
      ref.invalidate(sequenceListProvider);
      ref.invalidate(favoriteSequenceListProvider);
      ref.invalidate(recentSequenceListProvider);
      ref.invalidate(homeOverviewProvider);
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

enum _SequenceFilter {
  all('전체'),
  favorites('즐겨찾기'),
  recent('최근 7일'),
  short('짧은 시퀀스'),
  long('긴 시퀀스');

  const _SequenceFilter(this.label);

  final String label;
}

enum _SequenceSort {
  recent('최근 수정순'),
  name('이름순'),
  stepsAscending('동작 적은순'),
  stepsDescending('동작 많은순');

  const _SequenceSort(this.label);

  final String label;
}

class _SequenceListItem {
  const _SequenceListItem({required this.sequence, required this.stepCount});

  final Sequence sequence;
  final int stepCount;

  bool get hasNote => (sequence.description ?? '').trim().isNotEmpty;
}

class _SequenceHeader extends StatelessWidget {
  const _SequenceHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '시퀀스',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            height: 1.16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$count개의 시퀀스',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _SequenceSearchField extends StatelessWidget {
  const _SequenceSearchField({
    required this.controller,
    required this.focusNode,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final hasValue = controller.text.trim().isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: focusNode.hasFocus ? primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
        decoration: InputDecoration(
          hintText: '시퀀스 검색',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.4),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.fromLTRB(52, 14, 48, 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              CupertinoIcons.search,
              size: 20,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 44),
          suffixIcon: hasValue
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: onClear,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color:
                            theme.textTheme.bodyMedium?.color?.withValues(
                              alpha: 0.1,
                            ) ??
                            Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 14,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 40),
        ),
      ),
    );
  }
}

class _FilterChipRow extends StatelessWidget {
  const _FilterChipRow({required this.activeFilter, required this.onChanged});

  final _SequenceFilter activeFilter;
  final ValueChanged<_SequenceFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: _SequenceFilter.values
            .map((filter) {
              final isSelected = filter == activeFilter;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: GestureDetector(
                  onTap: () => onChanged(filter),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primary : theme.cardColor,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isSelected ? 0.08 : 0.04,
                          ),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      filter.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _SortRow extends StatelessWidget {
  const _SortRow({required this.currentSortLabel, required this.onTap});

  final String currentSortLabel;
  final ValueChanged<BuildContext> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '정렬: $currentSortLabel',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
        Builder(
          builder: (buttonContext) {
            return GestureDetector(
              onTap: () => onTap(buttonContext),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.swap_vert_rounded,
                      size: 16,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '정렬',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SequenceListCard extends StatelessWidget {
  const _SequenceListCard({
    required this.item,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final _SequenceListItem item;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${item.stepCount}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '동작',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                          height: 1,
                          color: primary.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.sequence.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            Text(
                              _formatDate(item.sequence.updatedAt),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                            if (item.hasNote)
                              Text(
                                '· 수업 노트 있음',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _FavoriteButton(
                  isFavorite: item.sequence.isFavorite,
                  onTap: onToggleFavorite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.month}월 ${date.day}일';
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isFavorite
              ? primary.withValues(alpha: 0.1)
              : theme.scaffoldBackgroundColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
          size: 15,
          color: isFavorite ? primary : theme.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}

class _SequenceEmptyState extends StatelessWidget {
  const _SequenceEmptyState({required this.isSearchResult});

  final bool isSearchResult;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(CupertinoIcons.search, size: 28, color: primary),
          ),
          const SizedBox(height: 16),
          Text(
            isSearchResult ? '검색 결과가 없습니다' : '아직 시퀀스가 없어요',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _SequenceListErrorView extends StatelessWidget {
  const _SequenceListErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '시퀀스를 불러오지 못했습니다.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

class _FloatingCreateButton extends StatelessWidget {
  const _FloatingCreateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 64,
      height: 64,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Icon(
              Icons.add_rounded,
              size: 30,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
