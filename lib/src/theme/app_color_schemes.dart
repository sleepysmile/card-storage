import 'package:flutter/material.dart';

abstract final class AppColorSchemes {
  static const _seedColor = Color(0xFF6750A4);

  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.light,
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.dark,
  );
}
