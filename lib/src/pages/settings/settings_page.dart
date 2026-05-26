import 'dart:convert';
import 'dart:io';

import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:card_storage/src/providers/card_provider.dart';
import 'package:card_storage/src/providers/theme_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _isExporting = false;
  bool _isImporting = false;

  Future<void> _export() async {
    setState(() => _isExporting = true);

    try {
      final cards = await ref.read(cardRepositoryProvider).getAll();

      if (cards.isEmpty) {
        _showSnackBar('Нет карт для выгрузки');
        return;
      }

      final jsonBytes = utf8.encode(
        const JsonEncoder.withIndent('  ')
            .convert(cards.map((c) => c.toJson()).toList()),
      );

      final path = await FilePicker.platform.saveFile(
        dialogTitle: 'Сохранить карты',
        fileName: 'cards_export.json',
        bytes: jsonBytes,
      );

      if (path == null) return;

      // На десктопе file_picker возвращает путь, но не пишет файл
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        await File(path).writeAsBytes(jsonBytes);
      }

      _showSnackBar('Выгружено карт: ${cards.length}');
    } catch (e) {
      _showSnackBar('Ошибка выгрузки: $e');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _import() async {
    setState(() => _isImporting = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Выбрать файл карт',
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final bytes = result.files.first.bytes;
      if (bytes == null) return;

      final List<dynamic> jsonList = jsonDecode(utf8.decode(bytes));
      final cards = jsonList
          .map((e) => StorageCardDto.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);

      if (cards.isEmpty) {
        _showSnackBar('Файл не содержит карт');
        return;
      }

      final repository = ref.read(cardRepositoryProvider);
      for (final card in cards) {
        await repository.save(card);
      }

      await ref.read(cardListCacheStoreProvider).invalidate();
      ref.invalidate(pagedCardListProvider);

      _showSnackBar('Импортировано карт: ${cards.length}');
    } on FormatException {
      _showSnackBar('Неверный формат файла');
    } catch (e) {
      _showSnackBar('Ошибка импорта: $e');
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedThemeMode = ref.watch(themeModeProvider);
    final isBusy = _isExporting || _isImporting;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Оформление',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Card(
            child: RadioGroup<AppThemeMode>(
              groupValue: selectedThemeMode,
              onChanged: (value) {
                if (value == null) return;
                ref.read(themeModeProvider.notifier).setThemeMode(value);
              },
              child: Column(
                children: AppThemeMode.values.map((themeMode) {
                  return RadioListTile<AppThemeMode>(
                    value: themeMode,
                    title: Text(themeMode.title),
                  );
                }).toList(growable: false),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Данные',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: _isExporting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_outlined),
                  title: const Text('Выгрузить карты'),
                  subtitle: const Text('Сохранить все карты в JSON-файл'),
                  trailing: const Icon(Icons.chevron_right),
                  enabled: !isBusy,
                  onTap: _export,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: _isImporting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download_outlined),
                  title: const Text('Импортировать карты'),
                  subtitle: const Text('Загрузить карты из JSON-файла'),
                  trailing: const Icon(Icons.chevron_right),
                  enabled: !isBusy,
                  onTap: _import,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
