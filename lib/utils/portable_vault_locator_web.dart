class PortableVaultLocator {
  static const vaultDirectoryName = 'RecordBooksData';
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

  static Future<void> locateOrCreate() async {
    throw UnsupportedError('Portable vault discovery is not available on web.');
  }
}
