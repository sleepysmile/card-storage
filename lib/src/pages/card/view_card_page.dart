import 'package:barcode_widget/barcode_widget.dart';
import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:card_storage/src/generated/l10n/app_localizations.dart';
import 'package:card_storage/src/providers/card_provider.dart';
import 'package:card_storage/src/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ViewCardPage extends ConsumerStatefulWidget {
  const ViewCardPage({super.key, required this.barcode});

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

  Future<void> _copyToClipboard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.copied)),
    );
  }

  Future<void> _openEditPage() async {
    await context.push<void>(AppRoutes.cardEditPath(widget.barcode));
  }

  Future<void> _deleteCard() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.deleteCardQuestion),
          content: Text(l10n.actionCannotBeUndone),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.delete),
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.viewCardTitle)),
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
                    Text(l10n.cardNotFound),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: Text(l10n.backToCardList),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () => _copyToClipboard(card.barcode),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
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
                            l10n.barcodeRenderError,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                    ),
                  ),
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
                      if (card.cardNumber?.isNotEmpty == true) ...[
                        const SizedBox(height: 16),
                        Text(
                          l10n.cardNumberLabel,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => _copyToClipboard(card.cardNumber!),
                          child: Row(
                            children: [
                              Text(
                                card.cardNumber!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.copy,
                                size: 14,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        l10n.barcodeLabel,
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
                      title: Text(l10n.editCardAction),
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
                        l10n.deleteCard,
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
