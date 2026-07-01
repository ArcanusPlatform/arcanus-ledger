export 'storage_paths_unsupported.dart'
    if (dart.library.io) 'storage_paths_native.dart'
    if (dart.library.html) 'storage_paths_web.dart';
