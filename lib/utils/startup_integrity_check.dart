export 'startup_integrity_check_unsupported.dart'
    if (dart.library.io) 'startup_integrity_check_native.dart'
    if (dart.library.html) 'startup_integrity_check_web.dart';
