class SafeRemovalResult {
  const SafeRemovalResult({
    required this.dataPath,
    required this.completedAt,
  });

  final String dataPath;
  final DateTime completedAt;
}

class PortableVaultService {
  static Future<SafeRemovalResult> prepareForSafeRemoval() async {
    throw UnsupportedError('Safe removal is not available on this platform.');
  }
}
