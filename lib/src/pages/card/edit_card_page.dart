import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:card_storage/src/providers/card_provider.dart';
import 'package:card_storage/src/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditCardPage extends ConsumerStatefulWidget {
  const EditCardPage({
    super.key,
    required this.barcode,
  });

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
      final repository = ref.read(cardRepositoryProvider);
      final nextBarcode = _barcodeController.text.trim();

      if (nextBarcode != _initialBarcode) {
        final existingCard = await repository.getByBarcode(nextBarcode);
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
    final isBusy = _isSaving || _isDeleting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование карты'),
        actions: [
          IconButton(
            onPressed: isBusy ? null : _deleteCard,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Удалить карту',
          ),
        ],
      ),
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
                        if (!isBusy) {
                          _saveCard();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: isBusy ? null : _openScanBarcodePage,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Сканировать barcode'),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: isBusy ? null : _saveCard,
                      child: Text(isBusy ? 'Сохранение...' : 'Сохранить'),
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
