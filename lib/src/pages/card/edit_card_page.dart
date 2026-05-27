import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:card_storage/src/generated/l10n/app_localizations.dart';
import 'package:card_storage/src/providers/card_provider.dart';
import 'package:card_storage/src/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditCardPage extends ConsumerStatefulWidget {
  const EditCardPage({super.key, required this.barcode});

  final String barcode;

  @override
  ConsumerState<EditCardPage> createState() => _EditCardPageState();
}

class _EditCardPageState extends ConsumerState<EditCardPage> {
  static const _minBarcodeLength = 6;
  static const _maxBarcodeLength = 64;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _barcodeController = TextEditingController();

  late final Future<StorageCardDto?> _cardFuture;
  late final String _initialBarcode;
  int _cardId = 0;

  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _initialBarcode = widget.barcode;
    _cardFuture = _loadCard();
  }

  Future<StorageCardDto?> _loadCard() async {
    final repository = ref.read(cardRepositoryProvider);
    final card = await repository.getByBarcode(widget.barcode);

    if (card != null) {
      _cardId = card.id;
      _nameController.text = card.name;
      _cardNumberController.text = card.cardNumber ?? '';
      _barcodeController.text = card.barcode;
    }

    return card;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _saveCard() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final l10n = AppLocalizations.of(context)!;
      final repository = ref.read(cardRepositoryProvider);
      final nextBarcode = _barcodeController.text.trim();

      if (nextBarcode != _initialBarcode) {
        final existingCard = await repository.getByBarcode(nextBarcode);
        if (existingCard != null) {
          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.barcodeAlreadyExists)));
          return;
        }
      }

      if (nextBarcode != _initialBarcode) {
        await repository.delete(_initialBarcode);
      }

      await repository.save(
        StorageCardDto(
          id: _cardId,
          name: _nameController.text.trim(),
          barcode: nextBarcode,
          cardNumber: _cardNumberController.text.trim(),
        ),
      );

      await ref.read(pagedCardListProvider.notifier).refresh();

      if (!mounted) {
        return;
      }

      context.go(AppRoutes.home);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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

    setState(() {
      _isDeleting = true;
    });

    try {
      final repository = ref.read(cardRepositoryProvider);
      await repository.delete(_initialBarcode);
      await ref.read(pagedCardListProvider.notifier).refresh();

      if (!mounted) {
        return;
      }

      context.go(AppRoutes.home);
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  Future<void> _openScanBarcodePage() async {
    final barcode = await context.push<String>(AppRoutes.cardScan);
    if (!mounted || barcode == null || barcode.isEmpty) {
      return;
    }

    _barcodeController.text = barcode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBusy = _isSaving || _isDeleting;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editCardTitle)),
      body: FutureBuilder<StorageCardDto?>(
        future: _cardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
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

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.cardNameLabel,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.cardNameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cardNumberController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.cardNumberLabel,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _barcodeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(labelText: l10n.barcodeLabel),
                      validator: (value) {
                        final barcode = value?.trim() ?? '';

                        if (barcode.isEmpty) {
                          return l10n.barcodeRequired;
                        }

                        if (barcode.length < _minBarcodeLength) {
                          return l10n.barcodeTooShort(_minBarcodeLength);
                        }

                        if (barcode.length > _maxBarcodeLength) {
                          return l10n.barcodeTooLong(_maxBarcodeLength);
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (!isBusy) {
                          _saveCard();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: isBusy ? null : _openScanBarcodePage,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(l10n.scanBarcode),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: isBusy ? null : _saveCard,
                      child: Text(isBusy ? l10n.saving : l10n.save),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
