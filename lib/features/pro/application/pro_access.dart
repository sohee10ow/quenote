import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/init/app_startup_controller.dart';
import '../../sequence/application/sequence_providers.dart';
import '../presentation/widgets/pro_upgrade_sheet.dart';

const freeSequenceLimit = 3;

enum ProFeature {
  sequenceDuplication,
  stepDuplication,
  stepImages,
  backupRestore,
}

extension ProFeatureCopy on ProFeature {
  String get title {
    switch (this) {
      case ProFeature.sequenceDuplication:
        return '시퀀스 복제는 Pro 기능이에요';
      case ProFeature.stepDuplication:
        return '동작 복제는 Pro 기능이에요';
      case ProFeature.stepImages:
        return '동작 사진은 Pro 기능이에요';
      case ProFeature.backupRestore:
        return '백업과 복원은 Pro 기능이에요';
    }
  }

  String get description {
    switch (this) {
      case ProFeature.sequenceDuplication:
        return '잘 만든 시퀀스를 빠르게 복사해서 새 수업안을 만들 수 있어요.';
      case ProFeature.stepDuplication:
        return '동작 구성을 반복해서 작성할 때 더 빠르게 편집할 수 있어요.';
      case ProFeature.stepImages:
        return '동작 사진을 첨부하고 정리해서 수업 준비를 더 쉽게 할 수 있어요.';
      case ProFeature.backupRestore:
        return '기기 변경이나 실수에 대비해 시퀀스를 JSON 파일로 안전하게 보관할 수 있어요.';
    }
  }
}

final proAccessGuardProvider = Provider<ProAccessGuard>(
  (ref) => ProAccessGuard(ref.read),
);

class ProAccessGuard {
  const ProAccessGuard(this._read);

  final T Function<T>(ProviderListenable<T>) _read;

  Future<bool> ensureCanCreateSequence(BuildContext context) async {
    if (_read(isProEnabledProvider)) {
      return true;
    }

    final sequenceCount = await _read(
      sequenceRepositoryProvider,
    ).fetchSequences().then((items) => items.length);
    if (sequenceCount < freeSequenceLimit) {
      return true;
    }

    if (!context.mounted) {
      return false;
    }

    return showProUpgradeSheet(
      context,
      title: '무료 플랜은 시퀀스 3개까지 저장할 수 있어요',
      description: '베타 테스트 중에는 설정에서 Pro를 켜고 제한 없이 기능을 확인할 수 있어요.',
      onEnableBetaPro: () async {
        await _read(
          userSettingsControllerProvider.notifier,
        ).setBetaProOverrideEnabled(true);
      },
    );
  }

  Future<bool> ensureFeatureAccess(
    BuildContext context,
    ProFeature feature,
  ) async {
    if (_read(isProEnabledProvider)) {
      return true;
    }

    if (!context.mounted) {
      return false;
    }

    return showProUpgradeSheet(
      context,
      title: feature.title,
      description: feature.description,
      onEnableBetaPro: () async {
        await _read(
          userSettingsControllerProvider.notifier,
        ).setBetaProOverrideEnabled(true);
      },
    );
  }
}
