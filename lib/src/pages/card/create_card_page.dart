import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:card_storage/src/generated/l10n/app_localizations.dart';
import 'package:card_storage/src/providers/card_provider.dart';
import 'package:card_storage/src/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateCardPage extends ConsumerStatefulWidget {
  const CreateCardPage({super.key});

  @override
  ConsumerState<CreateCardPage> createState() => _CreateCardPageState();
}

class _CreateCardPageState extends ConsumerState<CreateCardPage> {
  static const _minBarcodeLength = 6;
  static const _maxBarcodeLength = 64;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _barcodeController = TextEditingController();

  bool _isSaving = false;

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
      final cardRepository = ref.read(cardRepositoryProvider);
      final existingCard = await cardRepository.getByBarcode(
        _barcodeController.text.trim(),
      );

      if (existingCard != null) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.barcodeAlreadyExists)),
        );
        return;
      }

      await cardRepository.save(
        StorageCardDto(
          id: DateTime.now().microsecondsSinceEpoch,
          name: _nameController.text.trim(),
          barcode: _barcodeController.text.trim(),
          cardNumber: _cardNumberController.text.trim(),
        ),
      );
      await ref.read(pagedCardListProvider.notifier).refresh();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cardSaved)),
      );
      context.pop(true);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createCardTitle)),
      body: SafeArea(
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
                  decoration: InputDecoration(labelText: l10n.cardNameLabel),
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
                  decoration: InputDecoration(labelText: l10n.cardNumberLabel),
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
                    if (!_isSaving) {
                      _saveCard();
                    }
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _openScanBarcodePage,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: Text(l10n.scanBarcode),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isSaving ? null : _saveCard,
                  child: Text(_isSaving ? l10n.saving : l10n.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
