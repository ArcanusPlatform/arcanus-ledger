class StoragePaths {
  static const String rootDir = '';

  static Future<void> initialize() async {}

  static String get database => _unsupportedPath('database');

  static String get backups => _unsupportedPath('backups');

  static String get exports => _unsupportedPath('exports');

  static String get attachments => _unsupportedPath('attachments');

  static String get settings => _unsupportedPath('settings');

  static String get temp => _unsupportedPath('temp');

  static String get logs => _unsupportedPath('logs');

  static String get cachedPdfs => _unsupportedPath('cached PDFs');

  static String get tempReports => _unsupportedPath('temp reports');

  static String get vaultMarker => _unsupportedPath('vault marker');

  static String databaseFile(String filename) => _unsupportedPath('database');

  static String backupFile(String filename) => _unsupportedPath('backups');

  static String exportFile(String filename) => _unsupportedPath('exports');

  static String attachmentFile(String filename) =>
      _unsupportedPath('attachments');

  static String settingsFile(String filename) => _unsupportedPath('settings');

  static String logFile(String filename) => _unsupportedPath('logs');

  static String cachedPdfFile(String filename) =>
      _unsupportedPath('cached PDFs');

  static String tempReportFile(String filename) =>
      _unsupportedPath('temp reports');

  static String _unsupportedPath(String category) {
    throw UnsupportedError('StoragePaths.$category is not available here.');
  }
}
