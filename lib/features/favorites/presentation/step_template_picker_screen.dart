import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sequence/application/step_template_providers.dart';
import '../../sequence/domain/enums/step_template_category.dart';
import 'widgets/step_template_library_view.dart';

class StepTemplatePickerScreen extends ConsumerStatefulWidget {
  const StepTemplatePickerScreen({super.key});

  @override
  ConsumerState<StepTemplatePickerScreen> createState() =>
      _StepTemplatePickerScreenState();
}

class _StepTemplatePickerScreenState
    extends ConsumerState<StepTemplatePickerScreen> {
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
              title: '즐겨찾기에서 가져오기',
              subtitle: '자주 쓰는 동작 템플릿을 골라 현재 시퀀스에 추가하세요.',
              templates: templates,
              selectedCategory: _selectedCategory,
              onCategoryChanged: (category) {
                setState(() => _selectedCategory = category);
              },
              onTapTemplate: (template) =>
                  Navigator.of(context).pop(template.id),
              emptyTitle: '저장된 동작 템플릿이 없어요',
              emptyDescription: '기존 동작 상세에서 즐겨찾기에 저장한 뒤 다시 선택할 수 있어요.',
            );
          },
        ),
      ),
    );
  }
}
