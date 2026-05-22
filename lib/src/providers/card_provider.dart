import 'package:card_storage/src/database/app_database.dart';
import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:card_storage/src/repositories/card_cache_store.dart';
import 'package:card_storage/src/repositories/card_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return DriftCardRepository(ref.watch(appDatabaseProvider));
});

final cardListCacheStoreProvider = Provider<CardListCacheStore>((ref) {
  return CardListCacheStore();
});

class CardSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) {
    state = value;
  }

  void clear() {
    state = '';
  }
}

final cardSearchQueryProvider =
    NotifierProvider<CardSearchQueryNotifier, String>(
      CardSearchQueryNotifier.new,
    );

class CardListState {
  const CardListState({
    required this.cards,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<StorageCardDto> cards;
  final bool hasMore;
  final bool isLoadingMore;

  CardListState copyWith({
    List<StorageCardDto>? cards,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CardListState(
      cards: cards ?? this.cards,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CardListNotifier extends AsyncNotifier<CardListState> {
  static const _pageSize = 20;

  @override
  Future<CardListState> build() async {
    final searchQuery = ref.watch(cardSearchQueryProvider);

    if (searchQuery.isEmpty) {
      final cached = await ref.read(cardListCacheStoreProvider).load();
      if (cached != null) {
        return CardListState(cards: cached.cards, hasMore: cached.hasMore);
      }
    }

    return _fetchPage();
  }

  Future<void> loadMore() async {
    final currentState =
        state is AsyncData<CardListState>
            ? (state as AsyncData<CardListState>).value
            : null;
    if (currentState == null ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = await _fetchNextPage(existingCards: currentState.cards);
      state = AsyncData(nextPage);
      await _persistIfNoSearch(nextPage);
    } catch (_) {
      state = AsyncData(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    await ref.read(cardListCacheStoreProvider).invalidate();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _fetchPage();
      await _persistIfNoSearch(result);
      return result;
    });
  }

  Future<CardListState> _fetchPage({
    List<StorageCardDto> existingCards = const [],
  }) async {
    final repository = ref.read(cardRepositoryProvider);
    final searchQuery = ref.read(cardSearchQueryProvider);
    final nextPage = await repository.getPage(
      offset: existingCards.length,
      limit: _pageSize,
      searchQuery: searchQuery,
    );

    return CardListState(
      cards: [...existingCards, ...nextPage],
      hasMore: nextPage.length == _pageSize,
    );
  }

  Future<CardListState> _fetchNextPage({
    required List<StorageCardDto> existingCards,
  }) {
    return _fetchPage(existingCards: existingCards);
  }

  Future<void> _persistIfNoSearch(CardListState listState) async {
    if (ref.read(cardSearchQueryProvider).isNotEmpty) return;
    await ref.read(cardListCacheStoreProvider).save(
          CardListCacheEntry(
            cards: listState.cards,
            hasMore: listState.hasMore,
          ),
        );
  }
}

final pagedCardListProvider =
    AsyncNotifierProvider<CardListNotifier, CardListState>(
      CardListNotifier.new,
    );
