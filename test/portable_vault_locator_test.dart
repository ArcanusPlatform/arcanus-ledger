import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:recordkeep/utils/portable_vault_locator_native.dart';

void main() {
  group('PortableVaultLocator', () {
    late Directory tempRoot;

    setUp(() async {
      tempRoot = await Directory.systemTemp.createTemp(
        'recordkeep_vault_test_',
      );
    });

    tearDown(() async {
      if (await tempRoot.exists()) {
        await tempRoot.delete(recursive: true);
      }
    });

    test('creates a marker and required portable vault directories', () async {
      final vault = PortableVaultLocator.portableVaultForRoot(tempRoot);

      await PortableVaultLocator.ensureVaultStructure(vault);

      expect(
        await File(p.join(vault.path, '.recordkeep_vault')).exists(),
        true,
      );
      expect(await Directory(p.join(vault.path, 'database')).exists(), true);
      expect(await Directory(p.join(vault.path, 'backups')).exists(), true);
      expect(await Directory(p.join(vault.path, 'exports')).exists(), true);
      expect(await Directory(p.join(vault.path, 'attachments')).exists(), true);
      expect(await Directory(p.join(vault.path, 'logs')).exists(), true);
      expect(await Directory(p.join(vault.path, 'temp')).exists(), true);
      expect(
        await Directory(p.join(vault.path, 'temp', 'cached_pdfs')).exists(),
        true,
      );
      expect(
        await Directory(p.join(vault.path, 'temp', 'reports')).exists(),
        true,
      );
    });

    test('locates a vault by marker under candidate volume roots', () async {
      final otherVolume = Directory(p.join(tempRoot.path, 'OtherVolume'));
      final vaultVolume = Directory(p.join(tempRoot.path, 'VaultVolume'));
      final vault = PortableVaultLocator.portableVaultForRoot(vaultVolume);

      await otherVolume.create(recursive: true);
      await PortableVaultLocator.ensureVaultStructure(vault);

      final located = await PortableVaultLocator.locateExistingVault(
        candidateRoots: [otherVolume, vaultVolume],
      );

      expect(located?.path, vault.path);
    });

    test('locates a legacy vault by database file', () async {
      final vaultVolume = Directory(p.join(tempRoot.path, 'VaultVolume'));
      final vault = Directory(
        p.join(vaultVolume.path, PortableVaultLocator.legacyVaultDirectoryName),
      );
      final database = File(
        p.join(vault.path, 'database', PortableVaultLocator.databaseFileName),
      );

      await database.parent.create(recursive: true);
      await database.writeAsString('');

      final located = await PortableVaultLocator.locateExistingVault(
        candidateRoots: [vaultVolume],
      );

      expect(located?.path, vault.path);
    });

    test('approves only Arcanus Ledger Data locations outside lib', () {
      final approved = Directory(
        p.join(tempRoot.path, 'Arcanus', 'Arcanus Ledger', 'Data'),
      );
      final inLib = Directory(
        p.join(
          tempRoot.path,
          'Arcanus',
          'Arcanus Ledger',
          'lib',
          'Arcanus',
          'Arcanus Ledger',
          'Data',
        ),
      );
      final outsideArcanus = Directory(p.join(tempRoot.path, 'Data'));

      expect(PortableVaultLocator.isApprovedVaultLocation(approved), true);
      expect(PortableVaultLocator.isApprovedVaultLocation(inLib), false);
      expect(
        PortableVaultLocator.isApprovedVaultLocation(outsideArcanus),
        false,
      );
    });
  });
}
