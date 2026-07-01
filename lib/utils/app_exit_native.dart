import 'dart:io';

import 'package:flutter/services.dart';

class AppExit {
  static Future<void> closeApp() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await SystemNavigator.pop();
      return;
    }

    exit(0);
  }
}
