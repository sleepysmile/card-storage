import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

class HiveCardRepository implements CardRepository {
  static const boxName = 'card';

  Future<Box<StorageCardDto>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<StorageCardDto>(boxName);
    }

    return Hive.openBox<StorageCardDto>(boxName);
  }

  @override
  Future<List<StorageCardDto>> getAll() async {
    final box = await _openBox();
    final cards = box.values.toList(growable: false);
    cards.sort((left, right) => right.id.compareTo(left.id));
    return cards;
  }

  @override
  Future<List<StorageCardDto>> getPage({
    required int offset,
    required int limit,
    String searchQuery = '',
  }) async {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    final cards = (await getAll()).where((card) {
      if (normalizedQuery.isEmpty) {
        return true;
      }

      return card.name.toLowerCase().contains(normalizedQuery);
    }).toList(growable: false);

    if (offset >= cards.length) {
      return const [];
    }

    final end = (offset + limit).clamp(0, cards.length);
    return cards.sublist(offset, end);
  }

  @override
  Future<StorageCardDto?> getByBarcode(String barcode) async {
    final box = await _openBox();
    return box.get(barcode);
  }

  @override
  Future<void> save(StorageCardDto card) async {
    final box = await _openBox();
    await box.put(card.barcode, card);
  }

  @override
  Future<void> delete(String barcode) async {
    final box = await _openBox();
    await box.delete(barcode);
  }
}

Future<void> initializeCardStorage() async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(StorageCardDtoAdapter());
  }

  if (!Hive.isBoxOpen(HiveCardRepository.boxName)) {
    await Hive.openBox<StorageCardDto>(HiveCardRepository.boxName);
  }

  await _migrateCardIds();
}

Future<void> _migrateCardIds() async {
  final box = Hive.box<StorageCardDto>(HiveCardRepository.boxName);
  final cards = box.values.toList(growable: false);

  if (cards.every((card) => card.id > 0)) {
    return;
  }

  var nextIdBase = DateTime.now().microsecondsSinceEpoch - cards.length;

  for (final card in cards) {
    if (card.id > 0) {
      continue;
    }

    nextIdBase += 1;
    await box.put(
      card.barcode,
      card.copyWith(id: nextIdBase),
    );
  }
}
