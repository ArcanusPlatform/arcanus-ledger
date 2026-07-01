import 'dart:convert';
import 'dart:io';

import 'storage_paths.dart';

class AppSettingsStore {
  static const defaultPin = '1234';
  static const _fileName = 'app_settings.json';
  static const _encoder = JsonEncoder.withIndent('  ');

  static String get _filePath => StoragePaths.settingsFile(_fileName);

  static Future<Map<String, String>> readAll() async {
    final file = File(_filePath);
    if (!await file.exists()) return {};

    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map<String, dynamic>) return {};

    return decoded.map((key, value) => MapEntry(key, value?.toString() ?? ''));
  }

  static Future<String?> read(String key) async {
    final settings = await readAll();
    return settings[key];
  }

  static Future<String> readPin() async {
    return await read('app_pin') ?? defaultPin;
  }

  static Future<void> write(String key, String value) async {
    await writeAll({key: value});
  }

  static Future<void> writePin(String pin) async {
    await write('app_pin', pin);
  }

  static Future<void> writeAll(Map<String, String> values) async {
    final settings = await readAll();
    settings.addAll(values);

    await Directory(StoragePaths.settings).create(recursive: true);
    await File(_filePath)
        .writeAsString(_encoder.convert(settings), flush: true);
  }

  static Future<void> deleteAll() async {
    final file = File(_filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
