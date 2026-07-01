class DatabasePathService {
  static const databasePathKey = 'database_path';
  static const dataFolderPathKey = 'data_folder_path';

  static Future<String?> getDatabasePath() async => null;

  static Future<String?> getDataFolderPath() async => null;

  static Future<void> saveDatabasePath(String path) async {}

  static Future<String> saveDataFolder(String folderPath) async => folderPath;

  static Future<String> saveDatabaseFile(String databasePath) async =>
      databasePath;

  static Future<void> clear() async {}
}
