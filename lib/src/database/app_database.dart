import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@UseRowClass(StorageCardDto, generateInsertable: true)
class StorageCards extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get barcode => text()();
  TextColumn get cardNumber => text().nullable()();

  @override
  Set<Column> get primaryKey => {barcode};
}

@DriftDatabase(tables: [StorageCards])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'card_storage');
}
