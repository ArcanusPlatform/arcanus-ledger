import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import 'portable_vault_locator_native.dart';

class DatabasePathService {
  static const databasePathKey = 'database_path';
  static const dataFolderPathKey = 'data_folder_path';

  static Future<String?> getDatabasePath() async {
    final prefs = await _prefsOrNull();
    return _cleanPath(prefs?.getString(databasePathKey));
  }

  static Future<String?> getDataFolderPath() async {
    final prefs = await _prefsOrNull();
    return _cleanPath(prefs?.getString(dataFolderPathKey));
  }

  static Future<void> saveDatabasePath(String path) async {
    final file = File(path);
    if (!PortableVaultLocator.isApprovedDatabaseFile(file)) {
      throw ArgumentError(
        'Ledger database must be Arcanus/Arcanus Ledger/Data/database/'
        '${PortableVaultLocator.databaseFileName}.',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(databasePathKey, file.path);
  }

  static Future<String> saveDataFolder(String folderPath) async {
    final selected = Directory(folderPath);
    final vault = PortableVaultLocator.isApprovedVaultLocation(selected)
        ? selected
        : PortableVaultLocator.portableVaultForRoot(selected);
    if (!PortableVaultLocator.isApprovedVaultLocation(vault)) {
      throw ArgumentError(
        'Ledger data must be stored in Arcanus/Arcanus Ledger/Data.',
      );
    }

    await PortableVaultLocator.ensureVaultStructure(vault);

    final databasePath = p.join(
      vault.path,
      'database',
      PortableVaultLocator.databaseFileName,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(dataFolderPathKey, vault.path);
    await prefs.setString(databasePathKey, databasePath);
    return databasePath;
  }

  static Future<String> saveDatabaseFile(String databasePath) async {
    final file = File(databasePath);
    if (!PortableVaultLocator.isApprovedDatabaseFile(file)) {
      throw ArgumentError(
        'Ledger database must be Arcanus/Arcanus Ledger/Data/database/'
        '${PortableVaultLocator.databaseFileName}.',
      );
    }

    final root = _rootForDatabaseFile(file);
    await PortableVaultLocator.ensureVaultStructure(root);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(databasePathKey, file.path);
    await prefs.setString(dataFolderPathKey, root.path);
    return file.path;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(databasePathKey);
    await prefs.remove(dataFolderPathKey);
  }

  static Future<SharedPreferences?> _prefsOrNull() async {
    try {
      return await SharedPreferences.getInstance();
    } on MissingPluginException {
      return null;
    }
  }

  static Directory _rootForDatabaseFile(File file) {
    final databaseDirectory = file.parent;
    if (p.basename(databaseDirectory.path) == 'database') {
      return databaseDirectory.parent;
    }

    return databaseDirectory;
  }

  static String? _cleanPath(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    return path;
  }
}
