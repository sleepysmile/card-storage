import 'dart:convert';
import 'dart:io';

import 'package:card_storage/src/dto/storage_card_dto.dart';
import 'package:card_storage/src/generated/l10n/app_localizations.dart';
import 'package:card_storage/src/providers/card_provider.dart';
import 'package:card_storage/src/providers/locale_provider.dart';
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
    final l10n = AppLocalizations.of(context)!;

    try {
      final cards = await ref.read(cardRepositoryProvider).getAll();

      if (cards.isEmpty) {
        _showSnackBar(l10n.noCardsToExport);
        return;
      }

      final jsonBytes = utf8.encode(
        const JsonEncoder.withIndent('  ')
            .convert(cards.map((c) => c.toJson()).toList()),
      );

      final path = await FilePicker.platform.saveFile(
        dialogTitle: l10n.saveCardsDialogTitle,
        fileName: 'cards_export.json',
        bytes: jsonBytes,
      );

      if (path == null) return;

      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        await File(path).writeAsBytes(jsonBytes);
      }

      _showSnackBar(l10n.cardsExported(cards.length));
    } catch (e) {
      _showSnackBar(l10n.exportError(e.toString()));
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _import() async {
    setState(() => _isImporting = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: l10n.selectCardsFile,
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
        _showSnackBar(l10n.fileHasNoCards);
        return;
      }

      final repository = ref.read(cardRepositoryProvider);
      for (final card in cards) {
        await repository.save(card);
      }

      await ref.read(cardListCacheStoreProvider).invalidate();
      ref.invalidate(pagedCardListProvider);

      _showSnackBar(l10n.cardsImported(cards.length));
    } on FormatException {
      _showSnackBar(l10n.invalidFileFormat);
    } catch (e) {
      _showSnackBar(l10n.importError(e.toString()));
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

  String _themeTitle(AppLocalizations l10n, AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return l10n.themeSystem;
      case AppThemeMode.light:
        return l10n.themeLight;
      case AppThemeMode.dark:
        return l10n.themeDark;
    }
  }

  String _localeName(AppLocalizations l10n, Locale? locale) {
    if (locale == null) return l10n.languageSystem;
    switch (locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      default:
        return locale.languageCode;
    }
  }

  void _showLocaleSelector(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _LocaleSelectorSheet(
        selectedLocale: ref.read(localeProvider),
        onLocaleSelected: (locale) {
          ref.read(localeProvider.notifier).setLocale(locale);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedThemeMode = ref.watch(themeModeProvider);
    final selectedLocale = ref.watch(localeProvider);
    final isBusy = _isExporting || _isImporting;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.appearance,
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
                    title: Text(_themeTitle(l10n, themeMode)),
                  );
                }).toList(growable: false),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.language,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language_outlined),
              title: Text(_localeName(l10n, selectedLocale)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLocaleSelector(context),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.data,
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
                  title: Text(l10n.exportCards),
                  subtitle: Text(l10n.exportCardsSubtitle),
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
                  title: Text(l10n.importCards),
                  subtitle: Text(l10n.importCardsSubtitle),
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

class _LocaleOption {
  const _LocaleOption({required this.locale, required this.nativeName});

  final Locale? locale;
  final String nativeName;
}

class _LocaleSelectorSheet extends StatefulWidget {
  const _LocaleSelectorSheet({
    required this.selectedLocale,
    required this.onLocaleSelected,
  });

  final Locale? selectedLocale;
  final ValueChanged<Locale?> onLocaleSelected;

  @override
  State<_LocaleSelectorSheet> createState() => _LocaleSelectorSheetState();
}

class _LocaleSelectorSheetState extends State<_LocaleSelectorSheet> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static String _localeKey(Locale? locale) =>
      locale?.languageCode ?? 'system';

  List<_LocaleOption> _buildOptions(AppLocalizations l10n) {
    return [
      _LocaleOption(locale: null, nativeName: l10n.languageSystem),
      const _LocaleOption(locale: Locale('ru'), nativeName: 'Русский'),
      const _LocaleOption(locale: Locale('en'), nativeName: 'English'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allOptions = _buildOptions(l10n);
    final filtered = _query.isEmpty
        ? allOptions
        : allOptions
            .where((o) =>
                o.nativeName.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: l10n.language,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.noCardsFound,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            )
          else
            RadioGroup<String>(
              groupValue: _localeKey(widget.selectedLocale),
              onChanged: (value) {
                if (value == null) return;
                widget.onLocaleSelected(
                  value == 'system' ? null : Locale(value),
                );
              },
              child: Column(
                children: filtered.map((option) {
                  return RadioListTile<String>(
                    value: _localeKey(option.locale),
                    title: Text(option.nativeName),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
