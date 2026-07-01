import '../database/database.dart';

class StartupIntegrityException implements Exception {
  const StartupIntegrityException(this.message);

  final String message;

  @override
  String toString() => message;
}

class StartupIntegrityCheck {
  static Future<void> verifyStorage() async {}

  static Future<void> verifyDatabase(AppDatabase db) async {}
}
