import 'package:barcode_widget/barcode_widget.dart';
import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:card_storage/src/providers/card_provider.dart';
import 'package:card_storage/src/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ViewCardPage extends ConsumerStatefulWidget {
  const ViewCardPage({
    super.key,
    required this.barcode,
  });

  final String barcode;

  @override
  ConsumerState<ViewCardPage> createState() => _ViewCardPageState();
}

class _ViewCardPageState extends ConsumerState<ViewCardPage> {
  late Future<StorageCardDto?> _cardFuture;

  @override
  void initState() {
    super.initState();
    _cardFuture = _loadCard();
  }

  Future<StorageCardDto?> _loadCard() async {
    final repository = ref.read(cardRepositoryProvider);
    return repository.getByBarcode(widget.barcode);
  }

  Future<void> _openEditPage() async {
    await context.push<void>(AppRoutes.cardEditPath(widget.barcode));
  }

  Future<void> _deleteCard() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Удалить карту?'),
          content: const Text('Это действие нельзя отменить.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );

    if (approved != true) {
      return;
    }

    final repository = ref.read(cardRepositoryProvider);
    await repository.delete(widget.barcode);
    await ref.read(pagedCardListProvider.notifier).refresh();

    if (!mounted) {
      return;
    }

    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Просмотр карты'),
      ),
      body: FutureBuilder<StorageCardDto?>(
        future: _cardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final card = snapshot.data;
          if (card == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Карта не найдена'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: const Text('К списку карт'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: card.barcode,
                  drawText: true,
                  height: 140,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.black),
                  backgroundColor: Colors.white,
                  color: Colors.black,
                  errorBuilder: (context, error) {
                    return Center(
                      child: Text(
                        'Не удалось построить barcode',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Идентификатор',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.id.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Штрихкод',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.barcode,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: const Text('Редактировать карту'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _openEditPage,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      title: Text(
                        'Удалить карту',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _deleteCard,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
