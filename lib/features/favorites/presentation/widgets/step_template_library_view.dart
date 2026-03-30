import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../sequence/domain/entities/step_template.dart';
import '../../../sequence/domain/enums/side_type.dart';
import '../../../sequence/domain/enums/step_template_category.dart';

class StepTemplateLibraryView extends StatelessWidget {
  const StepTemplateLibraryView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.templates,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onTapTemplate,
    required this.emptyTitle,
    required this.emptyDescription,
    this.onDeleteTemplate,
  });

  final String title;
  final String subtitle;
  final List<StepTemplate> templates;
  final StepTemplateCategory? selectedCategory;
  final ValueChanged<StepTemplateCategory?> onCategoryChanged;
  final ValueChanged<StepTemplate> onTapTemplate;
  final ValueChanged<StepTemplate>? onDeleteTemplate;
  final String emptyTitle;
  final String emptyDescription;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      children: [
        _Header(title: title, subtitle: subtitle),
        const SizedBox(height: 20),
        _CategoryFilterRow(
          selectedCategory: selectedCategory,
          onCategoryChanged: onCategoryChanged,
        ),
        const SizedBox(height: 20),
        if (templates.isEmpty)
          _EmptyState(title: emptyTitle, description: emptyDescription)
        else
          Column(
            children: List<Widget>.generate(templates.length, (index) {
              final template = templates[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == templates.length - 1 ? 0 : AppSpacing.sm,
                ),
                child: _TemplateCard(
                  template: template,
                  onTap: () => onTapTemplate(template),
                  onDelete: onDeleteTemplate == null
                      ? null
                      : () => onDeleteTemplate!(template),
                ),
              );
            }),
          ),
      ],
    );
  }
}

class StepTemplatePreviewSheet extends StatelessWidget {
  const StepTemplatePreviewSheet({
    super.key,
    required this.template,
    this.onDelete,
  });

  final StepTemplate template;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sideLabel = _sideLabel(template.sideType);

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.poseName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Chip(label: template.category.label),
                          _Chip(label: '${template.breathCount}호흡'),
                          if (sideLabel.isNotEmpty) _Chip(label: sideLabel),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(CupertinoIcons.xmark),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (template.preparationCue.trim().isNotEmpty)
              _Section(
                title: '준비동작 큐잉',
                content: template.preparationCue.trim(),
              ),
            if (template.breathCues.any((cue) => cue.text.trim().isNotEmpty))
              _Section(
                title: '호흡 큐잉',
                content: template.breathCues
                    .where((cue) => cue.text.trim().isNotEmpty)
                    .map((cue) => '${cue.breathIndex}호흡  ${cue.text.trim()}')
                    .join('\n'),
              ),
            if (template.releaseCue.trim().isNotEmpty)
              _Section(title: '동작 푸는 큐잉', content: template.releaseCue.trim()),
            if ((template.cautionNote ?? '').trim().isNotEmpty)
              _Section(title: '주의사항', content: template.cautionNote!.trim()),
            if ((template.beginnerModificationNote ?? '').trim().isNotEmpty)
              _Section(
                title: '초보자 변형 동작',
                content: template.beginnerModificationNote!.trim(),
              ),
            if (onDelete != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(CupertinoIcons.trash),
                  label: const Text('템플릿 삭제'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(CupertinoIcons.star_fill, color: primary, size: 22),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.82,
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

class _CategoryFilterRow extends StatelessWidget {
  const _CategoryFilterRow({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final StepTemplateCategory? selectedCategory;
  final ValueChanged<StepTemplateCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final categories = StepTemplateCategory.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryChip(
            label: '전체',
            selected: selectedCategory == null,
            onTap: () => onCategoryChanged(null),
          ),
          const SizedBox(width: 8),
          ...List<Widget>.generate(categories.length, (index) {
            final category = categories[index];
            return Padding(
              padding: EdgeInsets.only(
                right: index == categories.length - 1 ? 0 : 8,
              ),
              child: _CategoryChip(
                label: category.label,
                selected: category == selectedCategory,
                onTap: () => onCategoryChanged(category),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: selected ? primary : theme.cardColor,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.onTap,
    this.onDelete,
  });

  final StepTemplate template;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = _previewText(template);
    final sideLabel = _sideLabel(template.sideType);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          template.poseName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _Chip(label: template.category.label),
                        if (sideLabel.isNotEmpty) _Chip(label: sideLabel),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      preview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${template.breathCount}호흡',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.75,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(CupertinoIcons.trash, size: 20),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(CupertinoIcons.chevron_right, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(CupertinoIcons.star, size: 30),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

String stepTemplatePreviewText(StepTemplate template) => _previewText(template);

String _previewText(StepTemplate template) {
  final parts = <String>[];
  if (template.preparationCue.trim().isNotEmpty) {
    parts.add(template.preparationCue.trim());
  }
  final firstBreath = template.breathCues
      .map((cue) => cue.text.trim())
      .firstWhere((value) => value.isNotEmpty, orElse: () => '');
  if (firstBreath.isNotEmpty) {
    parts.add(firstBreath);
  }
  if (template.releaseCue.trim().isNotEmpty) {
    parts.add(template.releaseCue.trim());
  }
  if (parts.isEmpty) {
    return '큐잉이 아직 없습니다.';
  }
  return parts.join(' · ');
}

String _sideLabel(SideType sideType) {
  switch (sideType) {
    case SideType.left:
      return '왼쪽';
    case SideType.right:
      return '오른쪽';
    case SideType.both:
      return '좌/우 반복';
    case SideType.none:
      return '';
  }
}
