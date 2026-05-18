import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:card_storage/src/repositories/card_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return HiveCardRepository();
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
  Future<CardListState> build() {
    ref.watch(cardSearchQueryProvider);
    return _loadPage();
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
      state = AsyncData(
        await _loadPage(existingCards: currentState.cards),
      );
    } catch (_) {
      state = AsyncData(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadPage);
  }

  Future<CardListState> _loadPage({
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
}

final pagedCardListProvider =
    AsyncNotifierProvider<CardListNotifier, CardListState>(
      CardListNotifier.new,
    );
