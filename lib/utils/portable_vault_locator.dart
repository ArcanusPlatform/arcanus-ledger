export 'portable_vault_locator_unsupported.dart'
    if (dart.library.io) 'portable_vault_locator_native.dart'
    if (dart.library.html) 'portable_vault_locator_web.dart';
