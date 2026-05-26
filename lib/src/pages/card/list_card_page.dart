import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:card_storage/src/providers/card_provider.dart';
import 'package:card_storage/src/routes/app_routes.dart';
import 'package:card_storage/src/widgets/control_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ListCardPage extends StatelessWidget {
  const ListCardPage({super.key});

  Future<void> _openCreateCardPage(BuildContext context) async {
    await context.push<void>(AppRoutes.cardCreate);
  }

  Future<void> _openViewCardPage(
    BuildContext context,
    StorageCardDto card,
  ) async {
    await context.push<void>(AppRoutes.cardViewPath(card.barcode));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ControlPanel(
            onAddCardPressed: () => _openCreateCardPage(context),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final cardsAsync = ref.watch(pagedCardListProvider);
                final searchQuery = ref.watch(cardSearchQueryProvider);

                return cardsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text('Не удалось загрузить карты: $error'),
                  ),
                  data: (cardListState) {
                    if (cardListState.cards.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.credit_card_off_outlined,
                              size: 56,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              searchQuery.trim().isEmpty
                                  ? 'Карт пока нет'
                                  : 'Карты не найдены',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        final metrics = notification.metrics;
                        final isNearBottom =
                            metrics.pixels >= metrics.maxScrollExtent - 200;

                        if (isNearBottom) {
                          ref.read(pagedCardListProvider.notifier).loadMore();
                        }

                        return false;
                      },
                      child: ListView.separated(
                        itemCount: cardListState.cards.length +
                            (cardListState.isLoadingMore ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          if (index >= cardListState.cards.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final card = cardListState.cards[index];

                          return _CardTile(
                            card: card,
                            onTap: () => _openViewCardPage(context, card),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.card,
    required this.onTap,
  });

  final StorageCardDto card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final firstLetter =
        card.name.trimLeft().isNotEmpty
            ? card.name.trimLeft()[0].toUpperCase()
            : '?';

    return Material(
      color: colorScheme.primary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  firstLetter,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  card.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: colorScheme.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
