import 'package:card_storage/src/app.dart';
import 'package:card_storage/src/repositories/card_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeCardStorage();

  runApp(const ProviderScope(child: App()));
}
