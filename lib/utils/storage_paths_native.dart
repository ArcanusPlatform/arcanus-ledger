import 'dart:io';

import 'package:path/path.dart' as p;

import 'database_path_service.dart';
import 'portable_vault_locator_native.dart';

class StoragePaths {
  static Directory? _rootDir;
  static String? _databaseFileOverride;

  static Directory get rootDir {
    final dir = _rootDir;
    if (dir == null) {
      throw StateError('StoragePaths.initialize() must be called before use.');
    }
    return dir;
  }

  static Future<void> initialize() async {
    if (_rootDir != null) return;

    final savedDataFolder = await DatabasePathService.getDataFolderPath();
    final savedDatabasePath = await DatabasePathService.getDatabasePath();

    if (savedDataFolder != null) {
      final vault = Directory(savedDataFolder);
      if (PortableVaultLocator.isApprovedVaultLocation(vault)) {
        await PortableVaultLocator.ensureVaultStructure(vault);
        _rootDir = vault;
        _databaseFileOverride = _approvedDatabaseOverrideOrNull(
          savedDatabasePath,
        );
        return;
      }
    }

    if (savedDatabasePath != null) {
      final databaseFile = File(savedDatabasePath);
      if (PortableVaultLocator.isApprovedDatabaseFile(databaseFile)) {
        final vault = _rootForDatabaseFile(databaseFile);
        await PortableVaultLocator.ensureVaultStructure(vault);
        _rootDir = vault;
        _databaseFileOverride = databaseFile.path;
        return;
      }
    }

    if (savedDataFolder != null || savedDatabasePath != null) {
      await DatabasePathService.clear();
    }

    _rootDir = await PortableVaultLocator.locateOrCreate();
    _databaseFileOverride = null;
  }

  static String get database {
    final override = _databaseFileOverride;
    if (override != null) return File(override).parent.path;

    return p.join(rootDir.path, 'database');
  }

  static String get backups => p.join(rootDir.path, 'backups');

  static String get exports => p.join(rootDir.path, 'exports');

  static String get attachments => p.join(rootDir.path, 'attachments');

  static String get settings => database;

  static String get temp => p.join(rootDir.path, 'temp');

  static String get logs => p.join(rootDir.path, 'logs');

  static String get cachedPdfs => p.join(temp, 'cached_pdfs');

  static String get tempReports => p.join(temp, 'reports');

  static String get vaultMarker =>
      p.join(rootDir.path, PortableVaultLocator.markerFileName);

  static String databaseFile(String filename) {
    return _databaseFileOverride ?? p.join(database, filename);
  }

  static String backupFile(String filename) => p.join(backups, filename);

  static String exportFile(String filename) => p.join(exports, filename);

  static String attachmentFile(String filename) =>
      p.join(attachments, filename);

  static String settingsFile(String filename) => p.join(settings, filename);

  static String logFile(String filename) => p.join(logs, filename);

  static String cachedPdfFile(String filename) => p.join(cachedPdfs, filename);

  static String tempReportFile(String filename) =>
      p.join(tempReports, filename);

  static Directory _rootForDatabaseFile(File file) {
    final databaseDirectory = file.parent;
    if (p.basename(databaseDirectory.path) == 'database') {
      return databaseDirectory.parent;
    }

    return databaseDirectory;
  }

  static String? _approvedDatabaseOverrideOrNull(String? path) {
    if (path == null) return null;

    final file = File(path);
    if (!PortableVaultLocator.isApprovedDatabaseFile(file)) {
      return null;
    }

    return file.path;
  }
}
