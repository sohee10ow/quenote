import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StepImageStorage {
  const StepImageStorage();

  Future<String> copyToAppStorage(String sourcePath) async {
    final copied = await copyToAppStorageIfExists(sourcePath);
    if (copied == null) {
      throw StateError('이미지 파일을 찾을 수 없습니다.');
    }
    return copied;
  }

  Future<String?> copyToAppStorageIfExists(String sourcePath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      return null;
    }

    final directory = await _imageDirectory();
    final extension = _extensionOf(sourcePath);
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final suffix = sourceFile.uri.pathSegments.isEmpty
        ? 0
        : sourceFile.uri.pathSegments.last.hashCode.abs();
    final targetPath = '${directory.path}/$timestamp-$suffix$extension';

    final copied = await sourceFile.copy(targetPath);
    return copied.path;
  }

  Future<bool> exists(String path) async {
    return File(path).exists();
  }

  Future<void> deleteFiles(Iterable<String> paths) async {
    for (final path in paths) {
      final file = File(path);
      if (!await file.exists()) {
        continue;
      }
      try {
        await file.delete();
      } on FileSystemException {
        continue;
      }
    }
  }

  Future<Directory> _imageDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final directory = Directory('${documentsDirectory.path}/step_images');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  String _extensionOf(String path) {
    final separatorIndex = path.lastIndexOf(Platform.pathSeparator);
    final extensionIndex = path.lastIndexOf('.');

    if (extensionIndex <= separatorIndex) {
      return '.jpg';
    }

    final extension = path.substring(extensionIndex);
    if (extension.length > 6) {
      return '.jpg';
    }

    return extension;
  }
}

const stepImageStorage = StepImageStorage();
