import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sequence/application/step_template_providers.dart';
import '../../sequence/application/sequence_providers.dart';
import '../../sequence/domain/entities/step_template.dart';
import '../../sequence/domain/enums/step_template_category.dart';
import 'widgets/step_template_library_view.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  StepTemplateCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(
      stepTemplateListProvider(_selectedCategory),
    );
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (templatesAsync.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('불러오기에 실패했습니다.'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => ref.invalidate(
                        stepTemplateListProvider(_selectedCategory),
                      ),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              );
            }

            final templates = templatesAsync.valueOrNull;
            if (templates == null) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 14),
              );
            }

            return StepTemplateLibraryView(
              title: '즐겨찾기',
              subtitle: '반복되는 동작이나 시작 스트레칭 동작을 템플릿으로 모아두고 필요할 때 다시 가져오세요.',
              templates: templates,
              selectedCategory: _selectedCategory,
              onCategoryChanged: (category) {
                setState(() => _selectedCategory = category);
              },
              onTapTemplate: (template) =>
                  _openTemplatePreview(context, template),
              onDeleteTemplate: (template) =>
                  _confirmDeleteTemplate(context, template),
              emptyTitle: '아직 저장된 템플릿이 없어요',
              emptyDescription: '시퀀스 안의 동작 상세에서 `즐겨찾기에 저장`을 누르면 여기에 모아둘 수 있어요.',
            );
          },
        ),
      ),
    );
  }

  Future<void> _openTemplatePreview(
    BuildContext context,
    StepTemplate template,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StepTemplatePreviewSheet(
          template: template,
          onDelete: () async {
            Navigator.of(context).pop();
            await _confirmDeleteTemplate(this.context, template);
          },
        );
      },
    );
  }

  Future<void> _confirmDeleteTemplate(
    BuildContext context,
    StepTemplate template,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('템플릿 삭제'),
          content: Text('${template.poseName} 템플릿을 삭제할까요?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await ref
          .read(sequenceRepositoryProvider)
          .deleteStepTemplate(template.id);
      ref.invalidate(stepTemplateListProvider(null));
      for (final category in StepTemplateCategory.values) {
        ref.invalidate(stepTemplateListProvider(category));
      }
      ref.invalidate(stepTemplateByIdProvider(template.id));
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFE89D91),
          content: Text('템플릿을 삭제하지 못했습니다. 다시 시도해주세요.'),
        ),
      );
    }
  }
}
