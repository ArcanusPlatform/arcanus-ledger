import 'package:universal_html/html.dart' as html;

class DatabasePathService {
  static const databasePathKey = 'database_path';
  static const dataFolderPathKey = 'data_folder_path';
  static const _prefix = 'recordkeep.';

  static Future<String?> getDatabasePath() async {
    return _cleanPath(html.window.localStorage['$_prefix$databasePathKey']);
  }

  static Future<String?> getDataFolderPath() async {
    return _cleanPath(html.window.localStorage['$_prefix$dataFolderPathKey']);
  }

  static Future<void> saveDatabasePath(String path) async {
    html.window.localStorage['$_prefix$databasePathKey'] = path;
  }

  static Future<String> saveDataFolder(String folderPath) async {
    html.window.localStorage['$_prefix$dataFolderPathKey'] = folderPath;
    return folderPath;
  }

  static Future<String> saveDatabaseFile(String databasePath) async {
    await saveDatabasePath(databasePath);
    return databasePath;
  }

  static Future<void> clear() async {
    html.window.localStorage.remove('$_prefix$databasePathKey');
    html.window.localStorage.remove('$_prefix$dataFolderPathKey');
  }

  static String? _cleanPath(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    return path;
  }
}
