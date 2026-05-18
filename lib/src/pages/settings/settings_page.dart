import 'package:card_storage/src/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedThemeMode = ref.watch(themeModeProvider);

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
            child: Column(
              children: AppThemeMode.values.map((themeMode) {
                return RadioListTile<AppThemeMode>(
                  value: themeMode,
                  groupValue: selectedThemeMode,
                  title: Text(themeMode.title),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    ref.read(themeModeProvider.notifier).setThemeMode(value);
                  },
                );
              }).toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}
