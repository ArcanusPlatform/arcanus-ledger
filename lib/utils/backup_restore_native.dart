import 'dart:convert';
import 'dart:io';

import 'storage_paths.dart';

Future<void> backupData(Map<String, dynamic> backup) async {
  final jsonString = jsonEncode(backup);
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final file = File(
    StoragePaths.backupFile('recordkeep_backup_$timestamp.json'),
  );
  await file.writeAsString(jsonString, flush: true);
}

Future<String?> restoreData() async {
  final backupDir = Directory(StoragePaths.backups);
  final dir = backupDir;

  // Find all backup files and pick the most recent one by timestamp in filename
  final backupFiles = dir
      .listSync()
      .whereType<File>()
      .where(
        (f) =>
            f.path.contains('recordkeep_backup_') && f.path.endsWith('.json'),
      )
      .toList()
    ..sort((a, b) => b.path.compareTo(a.path)); // descending = newest first

  if (backupFiles.isEmpty) return null;

  return await backupFiles.first.readAsString();
}
