import 'package:card_storage/src/database/app_database.dart';
import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:drift/drift.dart';

abstract class CardRepository {
  Future<List<StorageCardDto>> getAll();

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
  Future<List<StorageCardDto>> getAll() {
    return (_db.select(_db.storageCards)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.id)]))
        .get();
  }

  @override
  Future<List<StorageCardDto>> getPage({
    required int offset,
    required int limit,
    String searchQuery = '',
  }) async {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return (_db.select(_db.storageCards)
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.id)])
            ..limit(limit, offset: offset))
          .get();
    }

    // SQLite lower() doesn't handle Cyrillic — filter in Dart instead.
    final all = await (_db.select(_db.storageCards)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.id)]))
        .get();

    final filtered =
        all
            .where((c) => c.name.toLowerCase().contains(normalizedQuery))
            .toList();

    final start = offset;
    if (start >= filtered.length) return [];
    return filtered.sublist(start, (offset + limit).clamp(0, filtered.length));
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
