import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../home/application/home_providers.dart';
import '../../application/sequence_providers.dart';
import '../../application/step_editor_draft.dart';
import '../../data/local/step_image_storage.dart';
import '../../domain/enums/side_type.dart';

class StepEditorScreen extends ConsumerStatefulWidget {
  const StepEditorScreen({super.key, required this.sequenceId, this.stepId});

  final int sequenceId;
  final int? stepId;

  @override
  ConsumerState<StepEditorScreen> createState() => _StepEditorScreenState();
}

class _StepEditorScreenState extends ConsumerState<StepEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _poseNameController;
  late final TextEditingController _sanskritNameController;
  late final TextEditingController _preparationCueController;
  late final TextEditingController _releaseCueController;
  late final TextEditingController _cautionController;
  late final TextEditingController _beginnerController;
  final ImagePicker _imagePicker = ImagePicker();
  final List<TextEditingController> _breathCueControllers =
      <TextEditingController>[];
  final List<_StepImageDraft> _imageDrafts = <_StepImageDraft>[];

  SideType _sideType = SideType.none;
  bool _isBalancePose = false;
  int _breathCount = 3;
  bool _isReady = false;
  bool _isSubmitting = false;
  bool _showLiveValidation = false;
  StepEditorDraft _initialDraft = StepEditorDraft.initial();

  bool get _isEditMode => widget.stepId != null;
  bool get _canSave =>
      !_isSubmitting && _poseNameController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _poseNameController = TextEditingController();
    _sanskritNameController = TextEditingController();
    _preparationCueController = TextEditingController();
    _releaseCueController = TextEditingController();
    _cautionController = TextEditingController();
    _beginnerController = TextEditingController();
    _poseNameController.addListener(_handlePoseNameChanged);
    _syncBreathCueControllers(_breathCount, const <String>[]);
    _loadInitial();
  }

  @override
  void dispose() {
    _poseNameController.removeListener(_handlePoseNameChanged);
    _poseNameController.dispose();
    _sanskritNameController.dispose();
    _preparationCueController.dispose();
    _releaseCueController.dispose();
    _cautionController.dispose();
    _beginnerController.dispose();
    for (final controller in _breathCueControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handlePoseNameChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isReady) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CupertinoActivityIndicator(radius: 14)),
      );
    }

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
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Form(
                  key: _formKey,
                  autovalidateMode: _showLiveValidation
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 148),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionCard(
                          title: '기본 정보',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('동작 이름'),
                              const SizedBox(height: AppSpacing.xs),
                              _buildSingleLineField(
                                controller: _poseNameController,
                                hintText: '예: 다운독, 전사 자세 1',
                                maxLength: 20,
                                validator: (value) {
                                  if ((value ?? '').trim().isEmpty) {
                                    return '동작 이름을 입력해주세요.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              _buildFieldLabel('호흡 횟수'),
                              const SizedBox(height: AppSpacing.xs),
                              _buildBreathCountSelector(),
                              const SizedBox(height: AppSpacing.lg),
                              _buildFieldLabel('방향'),
                              const SizedBox(height: AppSpacing.xs),
                              _buildSideSelector(),
                              const SizedBox(height: AppSpacing.lg),
                              _buildFieldLabel('밸런스 동작'),
                              const SizedBox(height: AppSpacing.xs),
                              _buildBalanceRow(),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildSectionCard(
                          title: '준비동작 큐잉',
                          subtitle: '자세 진입 전 준비 및 셋업 큐',
                          child: _buildEditorialMultilineField(
                            controller: _preparationCueController,
                            hintText:
                                '예: 네발 자세에서 시작합니다\n손은 어깨 아래, 무릎은 골반 아래에 놓습니다',
                            maxLength: 500,
                            minLines: 5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildSectionCard(
                          title: '호흡 큐잉',
                          subtitle: '각 호흡마다 전달할 큐',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List<Widget>.generate(
                              _breathCueControllers.length,
                              (index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        index ==
                                            _breathCueControllers.length - 1
                                        ? 0
                                        : AppSpacing.md,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel('${index + 1}호흡'),
                                      const SizedBox(height: AppSpacing.xs),
                                      _buildEditorialMultilineField(
                                        controller:
                                            _breathCueControllers[index],
                                        hintText:
                                            '${index + 1}번째 호흡 때 전달할 큐를 작성하세요',
                                        maxLength: 300,
                                        minLines: 2,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildSectionCard(
                          title: '동작 푸는 큐잉',
                          subtitle: '자세에서 나올 때의 큐',
                          child: _buildEditorialMultilineField(
                            controller: _releaseCueController,
                            hintText: '예: 천천히 무릎을 바닥에 내려놓습니다\n차일드 포즈로 쉬어갑니다',
                            maxLength: 500,
                            minLines: 4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildSectionCard(
                          title: '주의사항',
                          subtitle: '안전 및 정렬 주의점',
                          backgroundColor: const Color(0xFFFFF7ED),
                          border: Border.all(
                            color: const Color(0xFFF3D3A1),
                            width: 1,
                          ),
                          leading: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFDE68A),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              CupertinoIcons.exclamationmark_circle_fill,
                              size: 18,
                              color: Color(0xFFD97706),
                            ),
                          ),
                          child: _buildEditorialMultilineField(
                            controller: _cautionController,
                            hintText:
                                '예: 목에 무리가 가지 않도록 주의합니다\n손목이 불편한 분은 주먹을 쥔 채로 진행하세요',
                            maxLength: 300,
                            minLines: 3,
                            fillColor: theme.cardColor,
                            focusedBorderColor: const Color(0xFFF59E0B),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildSectionCard(
                          title: '초보자 변형 동작',
                          subtitle: '쉬운 버전 또는 변형 옵션',
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.06,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.12,
                            ),
                            width: 1,
                          ),
                          leading: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.18,
                              ),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              CupertinoIcons.info_circle_fill,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          child: _buildEditorialMultilineField(
                            controller: _beginnerController,
                            hintText:
                                '예: 무릎을 바닥에 대고 진행할 수 있습니다\n블록을 손 아래 받쳐서 높이를 조절하세요',
                            maxLength: 300,
                            minLines: 3,
                            fillColor: theme.cardColor,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildImageSection(),
                        if (_isEditMode) ...[
                          const SizedBox(height: AppSpacing.lg),
                          Center(
                            child: TextButton(
                              onPressed: _isSubmitting ? null : _onDelete,
                              child: Text(
                                '동작 삭제',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.cardColor.withValues(alpha: 0.96),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
              child: _buildBottomSaveButton(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);

    return DecoratedBox(
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleIconButton(
                  icon: CupertinoIcons.back,
                  onTap: () async {
                    final shouldPop = await _onBackAttempt();
                    if (shouldPop && mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                _buildTopSaveButton(),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _isEditMode ? '동작 편집' : '새 동작 추가',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSaveButton() {
    final theme = Theme.of(context);
    final enabled = _canSave;

    return Material(
      color: theme.colorScheme.primary.withValues(alpha: enabled ? 1 : 0.4),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: enabled ? _onSave : null,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Text(
            '저장',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSaveButton() {
    final theme = Theme.of(context);
    final enabled = _canSave;

    return Material(
      color: theme.colorScheme.primary.withValues(alpha: enabled ? 1 : 0.4),
      borderRadius: const BorderRadius.all(AppRadius.button),
      child: InkWell(
        onTap: enabled ? _onSave : null,
        borderRadius: const BorderRadius.all(AppRadius.button),
        child: SizedBox(
          height: 56,
          child: Center(
            child: Text(
              _isSubmitting ? '저장 중...' : (_isEditMode ? '변경사항 저장' : '동작 추가하기'),
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final theme = Theme.of(context);

    return _buildSectionCard(
      title: '동작 사진',
      subtitle: '참고용 동작 이미지 첨부',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_imageDrafts.isNotEmpty) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _imageDrafts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final image = _imageDrafts[index];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(AppRadius.input),
                      child: Container(
                        color: theme.scaffoldBackgroundColor,
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) {
                            return Center(
                              child: Icon(
                                CupertinoIcons.photo,
                                size: 28,
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withValues(alpha: 0.35),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: Material(
                        color: const Color(0x88000000),
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: _isSubmitting
                              ? null
                              : () => setState(
                                  () => _imageDrafts.removeAt(index),
                                ),
                          customBorder: const CircleBorder(),
                          child: const SizedBox(
                            width: 28,
                            height: 28,
                            child: Icon(
                              CupertinoIcons.xmark,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Row(
            children: [
              Expanded(
                child: _buildImageActionButton(
                  icon: CupertinoIcons.camera,
                  label: '카메라',
                  onTap: _isSubmitting
                      ? null
                      : () => _pickImage(ImageSource.camera),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildImageActionButton(
                  icon: CupertinoIcons.photo_on_rectangle,
                  label: '갤러리',
                  onTap: _isSubmitting
                      ? null
                      : () => _pickImage(ImageSource.gallery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.all(AppRadius.input),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(AppRadius.input),
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: theme.colorScheme.onSurface.withValues(
                  alpha: onTap == null ? 0.4 : 1,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: onTap == null ? 0.4 : 1,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    String? subtitle,
    Widget? leading,
    Color? backgroundColor,
    BoxBorder? border,
  }) {
    final theme = Theme.of(context);
    final hasHighlightedHeader = leading != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: const BorderRadius.all(AppRadius.card),
        border: border,
        boxShadow: border == null
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasHighlightedHeader)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leading,
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildSectionTitleBlock(title, subtitle)),
              ],
            )
          else
            _buildSectionTitleBlock(title, subtitle),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }

  Widget _buildSectionTitleBlock(String title, String? subtitle) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.9),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSingleLineField({
    required TextEditingController controller,
    required String hintText,
    int? maxLength,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLength: maxLength,
      buildCounter: _buildCounter,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
      decoration: _fieldDecoration(hintText: hintText),
    );
  }

  Widget _buildEditorialMultilineField({
    required TextEditingController controller,
    required String hintText,
    required int maxLength,
    required int minLines,
    Color? fillColor,
    Color? focusedBorderColor,
  }) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      buildCounter: _buildCounter,
      minLines: minLines,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.6),
      decoration: _fieldDecoration(
        hintText: hintText,
        fillColor: fillColor,
        focusedBorderColor: focusedBorderColor,
        isMultiline: true,
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hintText,
    Color? fillColor,
    Color? focusedBorderColor,
    bool isMultiline = false,
  }) {
    final theme = Theme.of(context);
    final borderColor = Colors.transparent;
    final focusedColor = focusedBorderColor ?? theme.colorScheme.primary;

    return InputDecoration(
      hintText: hintText,
      hintStyle: theme.textTheme.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.6,
        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.35),
      ),
      filled: true,
      fillColor: fillColor ?? theme.scaffoldBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(AppRadius.input),
        borderSide: BorderSide(color: borderColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(AppRadius.input),
        borderSide: BorderSide(color: borderColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(AppRadius.input),
        borderSide: BorderSide(color: focusedColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(AppRadius.input),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(AppRadius.input),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
      ),
      errorStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.error,
      ),
      alignLabelWithHint: isMultiline,
    );
  }

  Widget? _buildCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    if (maxLength == null) {
      return null;
    }
    if (currentLength < (maxLength * 0.8).ceil()) {
      return null;
    }
    return Text('$currentLength/$maxLength');
  }

  Widget _buildBreathCountSelector() {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      children: [
        _buildCircleIconButton(
          icon: CupertinoIcons.minus,
          onTap: _breathCount > 1
              ? () => _onBreathCountChanged(_breathCount - 1)
              : null,
          backgroundColor: theme.scaffoldBackgroundColor,
          foregroundColor: theme.colorScheme.onSurface,
          borderColor: theme.dividerColor.withValues(alpha: 0.12),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.all(AppRadius.input),
            ),
            alignment: Alignment.center,
            child: Text(
              '$_breathCount호흡',
              style: theme.textTheme.titleMedium?.copyWith(
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildCircleIconButton(
          icon: CupertinoIcons.plus,
          onTap: _breathCount < 10
              ? () => _onBreathCountChanged(_breathCount + 1)
              : null,
          backgroundColor: theme.scaffoldBackgroundColor,
          foregroundColor: theme.colorScheme.onSurface,
          borderColor: theme.dividerColor.withValues(alpha: 0.12),
        ),
      ],
    );
  }

  Widget _buildSideSelector() {
    final options = <(SideType, String)>[
      (SideType.none, '없음'),
      (SideType.left, '왼쪽'),
      (SideType.right, '오른쪽'),
      (SideType.both, '양쪽'),
    ];

    return Row(
      children: List<Widget>.generate(options.length, (index) {
        final option = options[index];
        final selected = _sideType == option.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == options.length - 1 ? 0 : AppSpacing.xs,
            ),
            child: _buildSegmentButton(
              label: option.$2,
              selected: selected,
              onTap: () => setState(() => _sideType = option.$1),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBalanceRow() {
    final theme = Theme.of(context);
    final selected = _isBalancePose;

    return Material(
      color: selected
          ? theme.colorScheme.primary
          : theme.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.all(AppRadius.input),
      child: InkWell(
        onTap: () => setState(() => _isBalancePose = !_isBalancePose),
        borderRadius: const BorderRadius.all(AppRadius.input),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Center(
            child: Text(
              selected ? '밸런스 동작입니다' : '밸런스 동작 아님',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: selected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: selected
          ? theme.colorScheme.primary
          : theme.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.all(AppRadius.input),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(AppRadius.input),
        child: SizedBox(
          height: 44,
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: selected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback? onTap,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: backgroundColor ?? theme.scaffoldBackgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: borderColor == null
                ? null
                : Border.all(color: borderColor, width: 1),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18,
            color: (foregroundColor ?? theme.colorScheme.onSurface).withValues(
              alpha: onTap == null ? 0.35 : 1,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadInitial() async {
    if (_isEditMode) {
      final step = await ref
          .read(sequenceRepositoryProvider)
          .findStepById(widget.stepId!);
      if (!mounted) {
        return;
      }
      if (step == null) {
        _isReady = true;
        setState(() {});
        return;
      }

      _poseNameController.text = step.poseName;
      _sanskritNameController.text = step.sanskritName ?? '';
      _preparationCueController.text = step.preparationCue;
      _releaseCueController.text = step.releaseCue;
      _cautionController.text = step.cautionNote ?? '';
      _beginnerController.text = step.beginnerModificationNote ?? '';
      _sideType = step.sideType;
      _isBalancePose = step.isBalancePose;
      _breathCount = step.breathCount;
      _imageDrafts
        ..clear()
        ..addAll(
          step.imagePaths.map(
            (path) => _StepImageDraft(path: path, isPersisted: true),
          ),
        );
      _syncBreathCueControllers(
        _breathCount,
        step.breathCues.map((cue) => cue.text).toList(growable: false),
      );
    }

    _initialDraft = _currentDraft();
    _isReady = true;
    setState(() {});
  }

  Future<void> _onBreathCountChanged(int nextValue) async {
    if (nextValue == _breathCount) {
      return;
    }

    if (nextValue < _breathCount) {
      final removed = _breathCueControllers
          .sublist(nextValue)
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .isNotEmpty;

      if (removed) {
        final shouldRemove = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('호흡 수를 줄일까요?'),
            content: const Text('삭제되는 호흡 큐잉 내용이 있습니다. 계속할까요?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('확인'),
              ),
            ],
          ),
        );

        if (shouldRemove != true) {
          return;
        }
      }
    }

    setState(() {
      _breathCount = nextValue;
      _syncBreathCueControllers(nextValue, _breathTexts());
    });
  }

  Future<void> _onSave() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      setState(() => _showLiveValidation = true);
      return;
    }

    setState(() => _isSubmitting = true);
    var copiedImagePaths = <String>[];

    try {
      final preparedImages = await _prepareImagePathsForSave();
      copiedImagePaths = preparedImages.newlyCopiedPaths;

      await ref
          .read(sequenceRepositoryProvider)
          .upsertStep(
            sequenceId: widget.sequenceId,
            stepId: widget.stepId,
            poseName: _poseNameController.text.trim(),
            sanskritName: _sanskritNameController.text,
            sideType: _sideType,
            isBalancePose: _isBalancePose,
            breathCount: _breathCount,
            preparationCue: _preparationCueController.text,
            breathCues: _breathTexts(),
            releaseCue: _releaseCueController.text,
            cautionNote: _cautionController.text,
            beginnerModificationNote: _beginnerController.text,
            imagePaths: preparedImages.allPaths,
          );

      ref.invalidate(sequenceStepsProvider(widget.sequenceId));
      ref.invalidate(sequenceByIdProvider(widget.sequenceId));
      ref.invalidate(sequenceListProvider);
      ref.invalidate(sequenceStepCountsProvider);
      ref.invalidate(favoriteSequenceListProvider);
      ref.invalidate(recentSequenceListProvider);
      ref.invalidate(homeOverviewProvider);

      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('저장되었습니다.')));
        Navigator.of(context).pop();
      }
    } catch (_) {
      await stepImageStorage.deleteFiles(copiedImagePaths);
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
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (picked == null || !mounted) {
        return;
      }

      setState(() {
        _imageDrafts.add(
          _StepImageDraft(path: picked.path, isPersisted: false),
        );
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 불러오지 못했습니다. 다시 시도해주세요.')),
      );
    }
  }

  Future<_PreparedImagePaths> _prepareImagePathsForSave() async {
    final allPaths = <String>[];
    final newlyCopiedPaths = <String>[];

    try {
      for (final image in _imageDrafts) {
        if (image.isPersisted) {
          allPaths.add(image.path);
          continue;
        }

        final copiedPath = await stepImageStorage.copyToAppStorage(image.path);
        newlyCopiedPaths.add(copiedPath);
        allPaths.add(copiedPath);
      }
    } catch (_) {
      await stepImageStorage.deleteFiles(newlyCopiedPaths);
      rethrow;
    }

    return _PreparedImagePaths(
      allPaths: allPaths,
      newlyCopiedPaths: newlyCopiedPaths,
    );
  }

  Future<void> _onDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('동작을 삭제할까요?'),
        content: const Text('삭제하면 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || widget.stepId == null) {
      return;
    }

    try {
      await ref.read(sequenceRepositoryProvider).deleteStep(widget.stepId!);
      ref.invalidate(sequenceStepsProvider(widget.sequenceId));
      ref.invalidate(sequenceByIdProvider(widget.sequenceId));
      ref.invalidate(sequenceListProvider);
      ref.invalidate(sequenceStepCountsProvider);
      ref.invalidate(favoriteSequenceListProvider);
      ref.invalidate(recentSequenceListProvider);
      ref.invalidate(homeOverviewProvider);

      if (mounted) {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFE89D91),
            content: Text('삭제에 실패했습니다. 다시 시도해주세요.'),
          ),
        );
      }
    }
  }

  Future<bool> _onBackAttempt() async {
    if (!_isDirty()) {
      return true;
    }

    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('변경사항 확인'),
        content: const Text('저장하지 않은 변경사항이 있습니다. 나가시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('계속 편집'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('나가기'),
          ),
        ],
      ),
    );

    return leave ?? false;
  }

  bool _isDirty() {
    final current = _currentDraft();
    return current.poseName != _initialDraft.poseName ||
        current.sanskritName != _initialDraft.sanskritName ||
        current.sideType != _initialDraft.sideType ||
        current.isBalancePose != _initialDraft.isBalancePose ||
        current.breathCount != _initialDraft.breathCount ||
        current.preparationCue != _initialDraft.preparationCue ||
        !_sameList(current.breathCues, _initialDraft.breathCues) ||
        current.releaseCue != _initialDraft.releaseCue ||
        current.cautionNote != _initialDraft.cautionNote ||
        current.beginnerModificationNote !=
            _initialDraft.beginnerModificationNote ||
        !_sameList(current.imagePaths, _initialDraft.imagePaths);
  }

  bool _sameList(List<String> a, List<String> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  StepEditorDraft _currentDraft() {
    return StepEditorDraft(
      poseName: _poseNameController.text,
      sanskritName: _sanskritNameController.text,
      sideType: _sideType,
      isBalancePose: _isBalancePose,
      breathCount: _breathCount,
      preparationCue: _preparationCueController.text,
      breathCues: _breathTexts(),
      releaseCue: _releaseCueController.text,
      cautionNote: _cautionController.text,
      beginnerModificationNote: _beginnerController.text,
      imagePaths: _imageDrafts
          .map((image) => image.path)
          .toList(growable: false),
    );
  }

  List<String> _breathTexts() {
    return _breathCueControllers
        .map((controller) => controller.text)
        .toList(growable: false);
  }

  void _syncBreathCueControllers(int nextCount, List<String> previousValues) {
    while (_breathCueControllers.length > nextCount) {
      _breathCueControllers.removeLast().dispose();
    }

    while (_breathCueControllers.length < nextCount) {
      _breathCueControllers.add(TextEditingController());
    }

    for (var i = 0; i < nextCount; i++) {
      _breathCueControllers[i].text = i < previousValues.length
          ? previousValues[i]
          : '';
    }
  }
}

class _StepImageDraft {
  const _StepImageDraft({required this.path, required this.isPersisted});

  final String path;
  final bool isPersisted;
}

class _PreparedImagePaths {
  const _PreparedImagePaths({
    required this.allPaths,
    required this.newlyCopiedPaths,
  });

  final List<String> allPaths;
  final List<String> newlyCopiedPaths;
}
