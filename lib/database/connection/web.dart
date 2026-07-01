import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

Future<QueryExecutor> connect() async {
  final result = await WasmDatabase.open(
    databaseName: 'recordkeep_db',
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
    // Move any existing IndexedDB data to OPFS on first run
    moveExistingIndexedDbToOpfs: true,
  );

  if (result.missingFeatures.isNotEmpty) {
    // Log which storage features aren't available (e.g. no OPFS → falls back to IndexedDB)
    // ignore: avoid_print
    print('[Arcanus Ledger] drift web storage: ${result.chosenImplementation}, '
        'missing: ${result.missingFeatures}');
  }

  return result.resolvedExecutor;
}
