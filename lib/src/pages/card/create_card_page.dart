import 'package:card_storage/src/dto/storage_card_dto.dart';
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
      final cardRepository = ref.read(cardRepositoryProvider);
      final existingCard = await cardRepository.getByBarcode(
        _barcodeController.text.trim(),
      );

      if (existingCard != null) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Карта с таким штрихкодом уже существует'),
          ),
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
        const SnackBar(content: Text('Карта успешно сохранена')),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Создание карты')),
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
                  decoration: const InputDecoration(
                    labelText: 'Название карты',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите название карты';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cardNumberController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Номер карты',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _barcodeController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Штрихкод',
                  ),
                  validator: (value) {
                    final barcode = value?.trim() ?? '';

                    if (barcode.isEmpty) {
                      return 'Введите штрихкод';
                    }

                    if (barcode.length < _minBarcodeLength) {
                      return 'Штрихкод должен содержать минимум $_minBarcodeLength символов';
                    }

                    if (barcode.length > _maxBarcodeLength) {
                      return 'Штрихкод должен содержать не больше $_maxBarcodeLength символов';
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
                  label: const Text('Сканировать barcode'),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isSaving ? null : _saveCard,
                  child: Text(_isSaving ? 'Сохранение...' : 'Сохранить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
