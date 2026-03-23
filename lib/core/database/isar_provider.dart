import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'isar_collections.dart';

const _dbName = 'quenote';

final isarProvider = FutureProvider<Isar>((ref) async {
  final existing = Isar.instanceNames.contains(_dbName)
      ? Isar.getInstance(_dbName)
      : null;
  if (existing != null) {
    return existing;
  }

  final directory = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    isarSchemas,
    name: _dbName,
    directory: directory.path,
    inspector: false,
  );

  ref.onDispose(isar.close);
  return isar;
});
