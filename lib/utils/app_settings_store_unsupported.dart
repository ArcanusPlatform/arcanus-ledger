class AppSettingsStore {
  static const defaultPin = '1234';
  static final Map<String, String> _settings = {};

  static Future<Map<String, String>> readAll() async {
    return Map<String, String>.from(_settings);
  }

  static Future<String?> read(String key) async {
    return _settings[key];
  }

  static Future<String> readPin() async {
    return _settings['app_pin'] ?? defaultPin;
  }

  static Future<void> write(String key, String value) async {
    _settings[key] = value;
  }

  static Future<void> writePin(String pin) async {
    _settings['app_pin'] = pin;
  }

  static Future<void> writeAll(Map<String, String> values) async {
    _settings.addAll(values);
  }

  static Future<void> deleteAll() async {
    _settings.clear();
  }
}
