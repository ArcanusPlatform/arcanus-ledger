import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PortableVaultLocator {
  static const arcanusDirectoryName = 'Arcanus';
  static const ledgerDirectoryName = 'Arcanus Ledger';
  static const vaultDirectoryName = 'Data';
  static const legacyVaultDirectoryName = 'RecordBooksData';
  static const markerFileName = '.recordkeep_vault';
  static const databaseFileName = 'recordkeep_db.sqlite';

  static const requiredDirectoryNames = [
    'database',
    'backups',
    'exports',
    'attachments',
    'temp',
    'logs',
  ];

  static const _markerPayload = {
    'vaultVersion': 1,
    'app': 'RecordKeep',
    'portable': true,
  };

  static Future<Directory> locateOrCreate() async {
    final vault = await _creationVault();
    if (await isVault(vault)) {
      await ensureVaultStructure(vault);
      return vault;
    }

    final legacyVault = await _legacyVault();
    if (legacyVault != null &&
        !_sameDirectory(vault, legacyVault) &&
        !await isVault(vault)) {
      await _copyDirectoryContents(legacyVault, vault);
    }

    await ensureVaultStructure(vault);
    return vault;
  }

  static Future<Directory?> locateExistingVault({
    Iterable<Directory>? candidateRoots,
  }) async {
    final roots = candidateRoots ?? await candidateVolumeRoots();

    for (final root in _dedupeDirectories(roots)) {
      for (final vault in _candidateVaultsForRoot(root)) {
        if (await isVault(vault)) {
          return vault;
        }
      }
    }

    return null;
  }

  static Future<bool> isVault(Directory vault) async {
    try {
      if (!await vault.exists()) return false;

      final marker = File(p.join(vault.path, markerFileName));
      if (await marker.exists()) {
        return _hasValidMarker(marker);
      }

      return File(p.join(vault.path, 'database', databaseFileName)).exists();
    } on FileSystemException {
      return false;
    }
  }

  static Future<void> ensureVaultStructure(Directory vault) async {
    await vault.create(recursive: true);

    for (final directoryName in requiredDirectoryNames) {
      await Directory(
        p.join(vault.path, directoryName),
      ).create(recursive: true);
    }

    await Directory(
      p.join(vault.path, 'temp', 'cached_pdfs'),
    ).create(recursive: true);
    await Directory(
      p.join(vault.path, 'temp', 'reports'),
    ).create(recursive: true);

    await File(p.join(vault.path, markerFileName)).writeAsString(
      const JsonEncoder.withIndent('  ').convert(_markerPayload),
      flush: true,
    );
  }

  static Future<void> validateVault(Directory vault) async {
    if (!await vault.exists()) {
      throw PortableVaultLocatorException('Missing vault: ${vault.path}');
    }

    final marker = File(p.join(vault.path, markerFileName));
    if (!await _hasValidMarker(marker)) {
      throw PortableVaultLocatorException(
        'Missing or invalid vault marker: ${marker.path}',
      );
    }

    for (final directoryName in requiredDirectoryNames) {
      final directory = Directory(p.join(vault.path, directoryName));
      if (!await directory.exists()) {
        throw PortableVaultLocatorException(
          'Missing vault directory: ${directory.path}',
        );
      }
    }

    final cachedPdfs = Directory(p.join(vault.path, 'temp', 'cached_pdfs'));
    if (!await cachedPdfs.exists()) {
      throw PortableVaultLocatorException(
        'Missing vault directory: ${cachedPdfs.path}',
      );
    }

    final reports = Directory(p.join(vault.path, 'temp', 'reports'));
    if (!await reports.exists()) {
      throw PortableVaultLocatorException(
        'Missing vault directory: ${reports.path}',
      );
    }
  }

  static Directory portableVaultForRoot(Directory root) {
    final normalized = Directory(p.normalize(root.path));
    final name = p.basename(normalized.path);

    if (name == vaultDirectoryName &&
        p.basename(p.dirname(normalized.path)) == ledgerDirectoryName) {
      return normalized;
    }

    if (name == ledgerDirectoryName) {
      return Directory(p.join(normalized.path, vaultDirectoryName));
    }

    if (name == arcanusDirectoryName) {
      return Directory(
        p.join(normalized.path, ledgerDirectoryName, vaultDirectoryName),
      );
    }

    return Directory(
      p.join(
        normalized.path,
        arcanusDirectoryName,
        ledgerDirectoryName,
        vaultDirectoryName,
      ),
    );
  }

  static bool isApprovedVaultLocation(Directory vault) {
    final normalized = p.normalize(vault.absolute.path);
    if (_hasPathSegment(normalized, 'lib')) return false;

    return p.basename(normalized) == vaultDirectoryName &&
        p.basename(p.dirname(normalized)) == ledgerDirectoryName &&
        p.basename(p.dirname(p.dirname(normalized))) == arcanusDirectoryName;
  }

  static bool isApprovedDatabaseFile(File file) {
    final databaseDirectory = file.parent;
    final vault = p.basename(databaseDirectory.path) == 'database'
        ? databaseDirectory.parent
        : databaseDirectory;

    return p.basename(file.path) == databaseFileName &&
        isApprovedVaultLocation(vault);
  }

  static Future<List<Directory>> candidateVolumeRoots() async {
    final roots = <Directory>[];

    final explicitRoot = _explicitArcanusRoot();
    if (explicitRoot != null) {
      roots.add(explicitRoot);
    }

    final appRoot = _appBundleVolumeRoot();
    if (appRoot != null && !Platform.isIOS) {
      roots.add(appRoot);
    }

    if (Platform.isMacOS) {
      roots.addAll(await _childrenOf('/Volumes'));
    } else if (Platform.isWindows) {
      roots.addAll(_windowsDriveRoots());
    } else if (Platform.isLinux) {
      roots.addAll(await _linuxVolumeRoots());
    } else if (Platform.isAndroid) {
      roots.addAll(await _androidVolumeRoots());
    }

    final fallback = _executableAdjacentRoot();
    if (fallback != null) {
      roots.add(fallback);
    }

    if (p.basename(Platform.resolvedExecutable) == 'flutter_tester') {
      roots.add(Directory.systemTemp);
    }

    return _dedupeDirectories(roots).toList(growable: false);
  }

  static Future<Directory> _creationVault() async {
    final explicitDataRoot = _explicitDataRoot();
    if (explicitDataRoot != null &&
        isApprovedVaultLocation(explicitDataRoot) &&
        await _canWriteVault(explicitDataRoot)) {
      return explicitDataRoot;
    }

    final explicitRoot = _explicitArcanusRoot();
    if (explicitRoot != null) {
      final vault = portableVaultForRoot(explicitRoot);
      if (isApprovedVaultLocation(vault) && await _canWriteVault(vault)) {
        return vault;
      }
    }

    if (p.basename(Platform.resolvedExecutable) == 'flutter_tester') {
      return portableVaultForRoot(Directory.systemTemp);
    }

    final appRoot = _appBundleVolumeRoot();
    if (appRoot != null && !Platform.isIOS) {
      final vault = portableVaultForRoot(appRoot);
      if (isApprovedVaultLocation(vault) && await _canWriteVault(vault)) {
        return vault;
      }
    }

    if (Platform.isAndroid) {
      final roots = await _androidVolumeRoots();
      for (final root in roots) {
        final vault = portableVaultForRoot(root);
        if (isApprovedVaultLocation(vault) && await _canWriteVault(vault)) {
          return vault;
        }
      }

      throw const PortableVaultLocatorException(
        'No writable Android storage root was found for a portable vault.',
      );
    }

    final adjacentRoot = _executableAdjacentRoot();
    if (adjacentRoot != null) {
      final vault = portableVaultForRoot(adjacentRoot);
      if (isApprovedVaultLocation(vault) && await _canWriteVault(vault)) {
        return vault;
      }
    }

    if (_isArcanusPath(Directory.current)) {
      final currentVault = portableVaultForRoot(Directory.current);
      if (isApprovedVaultLocation(currentVault) &&
          await _canWriteVault(currentVault)) {
        return currentVault;
      }
    }

    throw const PortableVaultLocatorException(
      'No writable Arcanus Ledger data folder was found.',
    );
  }

  static Future<Directory?> _managedStorageRoot() async {
    try {
      return await getApplicationSupportDirectory();
    } on Exception {
      try {
        return await getApplicationDocumentsDirectory();
      } on Exception {
        return null;
      }
    }
  }

  static Directory? _explicitArcanusRoot() {
    for (final key in const ['ARCANUS_ROOT', 'ARCANUS_LEDGER_ROOT']) {
      final value = Platform.environment[key];
      if (value != null && value.trim().isNotEmpty) {
        return Directory(value.trim());
      }
    }

    return null;
  }

  static Directory? _explicitDataRoot() {
    final value = Platform.environment['ARCANUS_LEDGER_DATA_ROOT'];
    if (value == null || value.trim().isEmpty) return null;
    return Directory(value.trim());
  }

  static Directory? _appBundleVolumeRoot() {
    Directory dir = File(Platform.resolvedExecutable).parent;

    while (dir.path != dir.parent.path) {
      if (p.basename(dir.path) == 'Apps') {
        return dir.parent;
      }
      dir = dir.parent;
    }

    return null;
  }

  static Directory? _executableAdjacentRoot() {
    if (Platform.resolvedExecutable.isEmpty) return null;

    final executable = File(Platform.resolvedExecutable);
    if (Platform.isMacOS) {
      Directory dir = executable.parent;
      while (dir.path != dir.parent.path) {
        if (dir.path.endsWith('.app')) {
          return dir.parent;
        }
        dir = dir.parent;
      }
    }

    return executable.parent;
  }

  static Future<List<Directory>> _linuxVolumeRoots() async {
    final roots = <Directory>[];

    for (final base in ['/media', '/mnt', '/run/media']) {
      final baseDir = Directory(base);
      if (!await baseDir.exists()) continue;

      roots.add(baseDir);
      final firstLevel = await _children(baseDir);
      roots.addAll(firstLevel);

      if (base == '/media' || base == '/run/media') {
        for (final child in firstLevel) {
          roots.addAll(await _children(child));
        }
      }
    }

    return roots;
  }

  static List<Directory> _windowsDriveRoots() {
    return [
      for (var code = 'A'.codeUnitAt(0); code <= 'Z'.codeUnitAt(0); code++)
        Directory('${String.fromCharCode(code)}:\\'),
    ];
  }

  static Future<List<Directory>> _androidVolumeRoots() async {
    final roots = <Directory>[];

    for (final base in ['/storage', '/mnt/media_rw']) {
      final baseDir = Directory(base);
      if (!await baseDir.exists()) continue;

      final firstLevel = await _children(baseDir);
      roots.addAll(firstLevel.where((dir) => !_isAndroidSystemStorage(dir)));

      for (final child in firstLevel) {
        if (p.basename(child.path) == 'emulated') {
          roots.addAll(await _children(child));
        }
      }
    }

    roots.add(Directory('/storage/emulated/0'));
    roots.add(Directory('/sdcard'));

    return roots;
  }

  static bool _isAndroidSystemStorage(Directory directory) {
    final name = p.basename(directory.path);
    return name == 'self' || name == 'emulated';
  }

  static Future<List<Directory>> _childrenOf(String path) async {
    return _children(Directory(path));
  }

  static Future<List<Directory>> _children(Directory directory) async {
    try {
      if (!await directory.exists()) return const [];

      final children = <Directory>[];
      await for (final entity in directory.list(followLinks: false)) {
        if (entity is Directory) {
          children.add(entity);
        }
      }
      return children;
    } on FileSystemException {
      return const [];
    }
  }

  static Future<bool> _hasValidMarker(File marker) async {
    try {
      if (!await marker.exists()) return false;

      final decoded = jsonDecode(await marker.readAsString());
      if (decoded is! Map<String, dynamic>) return false;

      return decoded['vaultVersion'] == 1 &&
          decoded['app'] == 'RecordKeep' &&
          decoded['portable'] == true;
    } on FormatException {
      return false;
    } on FileSystemException {
      return false;
    }
  }

  static Future<bool> _canWriteVault(Directory root) async {
    try {
      await root.create(recursive: true);
    } on FileSystemException {
      return false;
    }

    final probe = File(
      p.join(
        root.path,
        '.recordkeep_write_probe_${DateTime.now().microsecondsSinceEpoch}',
      ),
    );

    try {
      await probe.writeAsString('ok', flush: true);
      return true;
    } on FileSystemException {
      return false;
    } finally {
      try {
        if (await probe.exists()) {
          await probe.delete();
        }
      } on FileSystemException {
        // The write check has already produced the result we need.
      }
    }
  }

  static Future<Directory?> _legacyVault() async {
    final managedRoot = await _managedStorageRoot();
    if (managedRoot != null) {
      final vault = Directory(
        p.join(managedRoot.path, legacyVaultDirectoryName),
      );
      if (await isVault(vault)) return vault;
    }

    final root = _executableAdjacentRoot();
    if (root == null) return null;

    final vault = Directory(p.join(root.path, legacyVaultDirectoryName));
    if (await isVault(vault)) return vault;

    return null;
  }

  static List<Directory> _candidateVaultsForRoot(Directory root) {
    final primary = portableVaultForRoot(root);
    final legacy = Directory(p.join(root.path, legacyVaultDirectoryName));

    if (_sameDirectory(primary, legacy)) {
      return [primary];
    }

    return [primary, legacy];
  }

  static Future<void> _copyDirectoryContents(
    Directory source,
    Directory destination,
  ) async {
    await destination.create(recursive: true);

    await for (final entity in source.list(followLinks: false)) {
      final targetPath = p.join(destination.path, p.basename(entity.path));

      if (entity is Directory) {
        await _copyDirectoryContents(entity, Directory(targetPath));
      } else if (entity is File) {
        final target = File(targetPath);
        if (!await target.exists()) {
          await target.parent.create(recursive: true);
          await entity.copy(targetPath);
        }
      }
    }
  }

  static bool _sameDirectory(Directory a, Directory b) {
    return p.normalize(a.absolute.path) == p.normalize(b.absolute.path);
  }

  static bool _hasPathSegment(String path, String segment) {
    final parts = p.split(path).map((part) => part.toLowerCase());
    return parts.contains(segment.toLowerCase());
  }

  static bool _isArcanusPath(Directory directory) {
    return p
        .split(p.normalize(directory.absolute.path))
        .any((part) => part.toLowerCase().contains('arcanus'));
  }

  static Iterable<Directory> _dedupeDirectories(
    Iterable<Directory> dirs,
  ) sync* {
    final seen = <String>{};

    for (final dir in dirs) {
      final normalized = p.normalize(dir.path);
      if (seen.add(normalized)) {
        yield Directory(normalized);
      }
    }
  }
}

class PortableVaultLocatorException implements Exception {
  const PortableVaultLocatorException(this.message);

  final String message;

  @override
  String toString() => message;
}
