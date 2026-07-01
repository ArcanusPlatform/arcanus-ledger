import 'dart:io';

import '../database/database.dart';
import 'storage_paths_native.dart';

class SafeRemovalResult {
  const SafeRemovalResult({
    required this.dataPath,
    required this.completedAt,
  });

  final String dataPath;
  final DateTime completedAt;
}

class PortableVaultService {
  static Future<SafeRemovalResult> prepareForSafeRemoval() async {
    await StoragePaths.initialize();
    await AppDatabase.prepareForRemoval();
    await _requestFileSystemFlush();

    return SafeRemovalResult(
      dataPath: StoragePaths.rootDir.path,
      completedAt: DateTime.now(),
    );
  }

  static Future<void> _requestFileSystemFlush() async {
    if (!Platform.isMacOS && !Platform.isLinux) return;

    final result = await Process.run('sync', const []);
    if (result.exitCode != 0) {
      throw Exception('Could not flush filesystem buffers: ${result.stderr}');
    }
  }
}
