import 'package:flutter_test/flutter_test.dart';
import 'package:recordkeep/database/database.dart';

import 'test_helpers.dart';
import 'test_setup.dart';

void main() {
  group('Lite sync queue', () {
    late AppDatabase db;

    setUp(() async {
      setupTests();
      db = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await TestDatabaseHelper.closeTestDatabase(db);
    });

    test('queues and marks lite customer changes as synced', () async {
      final eventId = await db.recordLiteSyncEvent(
        entityType: 'SALE',
        entityId: 101,
        operation: 'CREATE',
        payloadJson: '{"saleId":101}',
        createdAt: DateTime.utc(2026, 1, 1),
      );

      expect(eventId, greaterThan(0));

      final pendingCounts = await db.getLiteSyncCounts();
      expect(pendingCounts['PENDING'], 1);
      expect(pendingCounts['SYNCED'], 0);

      final pendingEvents = await db.getLiteSyncEvents(status: 'PENDING');
      expect(pendingEvents, hasLength(1));
      expect(pendingEvents.single.entityType, 'SALE');
      expect(pendingEvents.single.entityId, 101);

      await db.markLiteSyncEventSynced(eventId);

      final syncedCounts = await db.getLiteSyncCounts();
      expect(syncedCounts['PENDING'], 0);
      expect(syncedCounts['SYNCED'], 1);
    });
  });
}
