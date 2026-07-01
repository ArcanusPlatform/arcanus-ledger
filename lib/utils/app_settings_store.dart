export 'app_settings_store_unsupported.dart'
    if (dart.library.io) 'app_settings_store_native.dart'
    if (dart.library.html) 'app_settings_store_web.dart';
