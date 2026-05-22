# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                                                                         # Install dependencies
flutter run                                                                             # Run on connected device/emulator
flutter analyze                                                                         # Lint (uses flutter_lints)
flutter test                                                                            # Run tests
flutter build apk --split-per-abi                                                       # Build Android APK per-ABI (smaller)
flutter build appbundle                                                                 # Build Android App Bundle for Play Store
flutter build apk --obfuscate --split-debug-info=build/symbols --split-per-abi         # Release APK with obfuscation
flutter build ios                                                                       # Build iOS
dart run build_runner build --delete-conflicting-outputs                                # Regenerate drift code after schema changes
```

Run a single test file:
```bash
flutter test test/path/to/test_file.dart
```

## Architecture

**Card Storage** is a Flutter app for storing loyalty/membership cards with barcode display and scanning. UI strings are in Russian.

### Tech stack

- **State management**: Riverpod (`flutter_riverpod` ^3.3.1) — uses `Notifier`/`AsyncNotifier` with `NotifierProvider`/`AsyncNotifierProvider`
- **Routing**: `go_router` — declarative, all routes defined in `app_router.dart`
- **Local storage**: Drift (SQLite) — code-generated via `build_runner`; schema defined in `lib/src/database/app_database.dart`, generated output in `app_database.g.dart`
- **Barcode display**: `barcode_widget` (Code 128)
- **Barcode scanning**: `google_mlkit_barcode_scanning` + `camera` + `image_picker`; scanning is Android/iOS only

### Data model

`StorageCardDto` is the single model class used throughout pages and providers. The `barcode` field is the primary key in SQLite. The `id` field is `DateTime.now().microsecondsSinceEpoch` — used only for sort order (newest first). To add a new column: update the `StorageCards` table in `app_database.dart`, bump `schemaVersion`, add a `MigrationStrategy`, re-run `build_runner`.

### Repository layer

`CardRepository` (abstract interface) + `DriftCardRepository` (implementation in `card_repository.dart`). `AppDatabase` is provided as a lazy Riverpod singleton via `appDatabaseProvider` (drift opens the file on first access, no explicit `init` call needed). The repository is exposed via `cardRepositoryProvider`.

### Provider layer (`lib/src/providers/`)

- `cardRepositoryProvider` — singleton `HiveCardRepository`
- `cardSearchQueryProvider` — current search string; `pagedCardListProvider` watches it and resets pagination on change
- `pagedCardListProvider` — `AsyncNotifier<CardListState>` with `loadMore()` (append next page) and `refresh()` (reset to page 1); page size is 20
- `themeModeProvider` — `AppThemeMode` enum (system/light/dark); not persisted across restarts

### Routing structure (`lib/src/routes/`)

Two-level route structure:
- **Shell routes** (`/home`, `/settings`) — wrapped in `MainPage`, which renders the bottom navigation bar and the search field (only on `/home`)
- **Standalone routes** (`/cards/create`, `/cards/scan`, `/cards/view`, `/cards/edit`) — full-screen, no bottom nav; push onto the navigation stack
- `AppRoutes.normalize()` redirects unknown/root paths to `/home`; the router's `redirect` callback applies it on every navigation

### Theme

Material 3 throughout. `AppTheme` builds `lightTheme`/`darkTheme` from `AppColorSchemes` and `AppTextThemes`. All widget theme overrides (buttons, inputs, cards, snackbars) are centralized in `AppTheme._buildTheme()`.
