import 'dart:convert';
import 'dart:io';

import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:path_provider/path_provider.dart';

class CardListCacheEntry {
  const CardListCacheEntry({required this.cards, required this.hasMore});

  final List<StorageCardDto> cards;
  final bool hasMore;
}

class CardListCacheStore {
  static const _fileName = 'card_list_cache.json';

  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<CardListCacheEntry?> load() async {
    try {
      final file = await _file;
      if (!file.existsSync()) return null;
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final cards = (json['cards'] as List<dynamic>)
          .map((e) => StorageCardDto.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
      return CardListCacheEntry(
        cards: cards,
        hasMore: json['hasMore'] as bool,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> save(CardListCacheEntry entry) async {
    try {
      final file = await _file;
      await file.writeAsString(
        jsonEncode({
          'cards': entry.cards.map((c) => c.toJson()).toList(growable: false),
          'hasMore': entry.hasMore,
        }),
      );
    } catch (_) {}
  }

  Future<void> invalidate() async {
    try {
      final file = await _file;
      if (file.existsSync()) await file.delete();
    } catch (_) {}
  }
}
