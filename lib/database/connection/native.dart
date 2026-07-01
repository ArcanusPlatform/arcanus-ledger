import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../../utils/storage_paths.dart';

Future<QueryExecutor> connect() async {
  await StoragePaths.initialize();
  final file = File(StoragePaths.databaseFile('recordkeep_db.sqlite'));

  return NativeDatabase(file, logStatements: true);
}
