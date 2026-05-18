import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

extension AppThemeModeX on AppThemeMode {
  String get title {
    switch (this) {
      case AppThemeMode.system:
        return 'Системная';
      case AppThemeMode.light:
        return 'Светлая';
      case AppThemeMode.dark:
        return 'Тёмная';
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() => AppThemeMode.system;

  void setThemeMode(AppThemeMode mode) {
    state = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, AppThemeMode>(
  ThemeModeNotifier.new,
);
