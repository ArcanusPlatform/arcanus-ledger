import 'dart:io';

import 'package:path/path.dart' as p;

import '../database/database.dart';
import 'portable_vault_locator_native.dart';
import 'storage_paths_native.dart';

class StartupIntegrityException implements Exception {
  const StartupIntegrityException(this.message);

  final String message;

  @override
  String toString() => message;
}

class StartupIntegrityCheck {
  static const int minimumFreeBytes = 64 * 1024 * 1024;

  static Future<void> verifyStorage() async {
    await StoragePaths.initialize();
    await PortableVaultLocator.validateVault(StoragePaths.rootDir);

    await _verifyDirectory(StoragePaths.rootDir.path, 'data root');
    await _verifyFile(StoragePaths.vaultMarker, 'vault marker');
    await _verifyDirectory(StoragePaths.database, 'database');
    await _verifyDirectory(StoragePaths.backups, 'backups');
    await _verifyDirectory(StoragePaths.exports, 'exports');
    await _verifyDirectory(StoragePaths.attachments, 'attachments');
    await _verifyDirectory(StoragePaths.temp, 'temp');
    await _verifyDirectory(StoragePaths.cachedPdfs, 'cached PDFs');
    await _verifyDirectory(StoragePaths.tempReports, 'temp reports');
    await _verifyDirectory(StoragePaths.logs, 'logs');
    await _verifyWritable();
    await _verifyFreeSpace();
  }

  static Future<void> verifyDatabase(AppDatabase db) async {
    final result = await db.integrityCheck();
    if (result.toLowerCase() != 'ok') {
      throw StartupIntegrityException(
          'Database integrity check failed: $result');
    }

    await _verifyFile(
      StoragePaths.databaseFile(PortableVaultLocator.databaseFileName),
      'database file',
    );
  }

  static Future<void> _verifyDirectory(String path, String label) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      throw StartupIntegrityException('Missing $label directory: $path');
    }
  }

  static Future<void> _verifyFile(String path, String label) async {
    final file = File(path);
    if (!await file.exists()) {
      throw StartupIntegrityException('Missing $label: $path');
    }
  }

  static Future<void> _verifyWritable() async {
    final probe = File(
      StoragePaths.tempReportFile(
        '.startup_write_probe_${DateTime.now().microsecondsSinceEpoch}',
      ),
    );

    try {
      await probe.writeAsString('ok', flush: true);
      final value = await probe.readAsString();
      if (value != 'ok') {
        throw const StartupIntegrityException(
          'Portable storage write verification failed.',
        );
      }
    } on StartupIntegrityException {
      rethrow;
    } catch (error) {
      throw StartupIntegrityException(
        'Portable storage is not writable: $error',
      );
    } finally {
      try {
        if (await probe.exists()) {
          await probe.delete();
        }
      } on FileSystemException {
        // Best-effort cleanup after the write check.
      }
    }
  }

  static Future<void> _verifyFreeSpace() async {
    if (Platform.isAndroid || Platform.isIOS) return;

    final freeBytes = await _freeBytes(StoragePaths.rootDir.path);
    if (freeBytes < minimumFreeBytes) {
      throw StartupIntegrityException(
        'Portable storage has only ${_formatBytes(freeBytes)} free. '
        'At least ${_formatBytes(minimumFreeBytes)} is required.',
      );
    }
  }

  static Future<int> _freeBytes(String path) async {
    if (Platform.isWindows) {
      return _windowsFreeBytes(path);
    }

    return _posixFreeBytes(path);
  }

  static Future<int> _posixFreeBytes(String path) async {
    final result = await Process.run('df', ['-Pk', path]);
    if (result.exitCode != 0) {
      throw StartupIntegrityException(
        'Could not verify free space: ${result.stderr}',
      );
    }

    final lines = result.stdout
        .toString()
        .trim()
        .split(RegExp(r'\r?\n'))
        .where((line) => line.trim().isNotEmpty)
        .toList();
    if (lines.length < 2) {
      throw const StartupIntegrityException(
        'Could not verify free space: unexpected df output.',
      );
    }

    final columns = lines.last.trim().split(RegExp(r'\s+'));
    if (columns.length < 4) {
      throw const StartupIntegrityException(
        'Could not verify free space: missing available-space column.',
      );
    }

    final availableKb = int.tryParse(columns[3]);
    if (availableKb == null) {
      throw const StartupIntegrityException(
        'Could not verify free space: invalid available-space value.',
      );
    }

    return availableKb * 1024;
  }

  static Future<int> _windowsFreeBytes(String path) async {
    final root = p.rootPrefix(path);
    if (root.isEmpty) {
      throw StartupIntegrityException(
        'Could not determine Windows drive for path: $path',
      );
    }

    final drive = root.substring(0, 1);
    final result = await Process.run('powershell', [
      '-NoProfile',
      '-Command',
      '(Get-PSDrive -Name "$drive").Free',
    ]);
    if (result.exitCode != 0) {
      throw StartupIntegrityException(
        'Could not verify free space: ${result.stderr}',
      );
    }

    final freeBytes = int.tryParse(result.stdout.toString().trim());
    if (freeBytes == null) {
      throw const StartupIntegrityException(
        'Could not verify free space: invalid PowerShell output.',
      );
    }

    return freeBytes;
  }

  static String _formatBytes(int bytes) {
    final mib = bytes / (1024 * 1024);
    return '${mib.toStringAsFixed(1)} MB';
  }
}
