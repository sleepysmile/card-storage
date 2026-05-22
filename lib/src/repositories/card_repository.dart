import 'package:card_storage/src/database/app_database.dart';
import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:drift/drift.dart';

abstract class CardRepository {
  Future<List<StorageCardDto>> getPage({
    required int offset,
    required int limit,
    String searchQuery = '',
  });

  Future<StorageCardDto?> getByBarcode(String barcode);

  Future<void> save(StorageCardDto card);

  Future<void> delete(String barcode);
}

class DriftCardRepository implements CardRepository {
  DriftCardRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<StorageCardDto>> getPage({
    required int offset,
    required int limit,
    String searchQuery = '',
  }) {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    final query = _db.select(_db.storageCards)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.id)])
      ..limit(limit, offset: offset);

    if (normalizedQuery.isNotEmpty) {
      query.where((tbl) => tbl.name.lower().like('%$normalizedQuery%'));
    }

    return query.get();
  }

  @override
  Future<StorageCardDto?> getByBarcode(String barcode) {
    return (_db.select(_db.storageCards)
          ..where((tbl) => tbl.barcode.equals(barcode)))
        .getSingleOrNull();
  }

  @override
  Future<void> save(StorageCardDto card) {
    return _db
        .into(_db.storageCards)
        .insertOnConflictUpdate(card.toInsertable());
  }

  @override
  Future<void> delete(String barcode) {
    return (_db.delete(_db.storageCards)
          ..where((tbl) => tbl.barcode.equals(barcode)))
        .go();
  }
}
