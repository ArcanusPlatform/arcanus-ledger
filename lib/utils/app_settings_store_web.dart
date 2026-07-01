import 'dart:convert';

import 'package:universal_html/html.dart' as html;

class AppSettingsStore {
  static const defaultPin = '1234';
  static const _storageKey = 'recordkeep.app_settings';

  static Future<Map<String, String>> readAll() async {
    final raw = html.window.localStorage[_storageKey];
    if (raw == null || raw.isEmpty) return {};

    final decoded = jsonDecode(raw);
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
    html.window.localStorage[_storageKey] = jsonEncode(settings);
  }

  static Future<void> deleteAll() async {
    html.window.localStorage.remove(_storageKey);
  }
}
