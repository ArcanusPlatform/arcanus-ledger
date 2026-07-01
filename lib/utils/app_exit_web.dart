import 'package:flutter/services.dart';

class AppExit {
  static Future<void> closeApp() {
    return SystemNavigator.pop();
  }
}
