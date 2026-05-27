import 'package:card_storage/src/generated/l10n/app_localizations.dart';
import 'package:card_storage/src/providers/card_provider.dart';
import 'package:card_storage/src/routes/app_routes.dart';
import 'package:card_storage/src/widgets/app_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.routeName,
    required this.child,
  });

  final String routeName;
  final Widget child;

  String _localizedTitle(BuildContext context, String routeName) {
    final l10n = AppLocalizations.of(context)!;
    switch (routeName) {
      case AppRoutes.settings:
        return l10n.navSettings;
      default:
        return l10n.navHome;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = AppRoutes.indexFor(routeName);
    final isHomeRoute = routeName == AppRoutes.home;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isHomeRoute ? 0 : kToolbarHeight,
        title: isHomeRoute
            ? null
            : Text(_localizedTitle(context, routeName)),
        bottom: isHomeRoute
            ? const PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: _CardSearchField(),
              )
            : null,
      ),
      body: child,
      bottomNavigationBar: AppBottomBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          final nextRoute = AppRoutes.routeForIndex(index);
          if (nextRoute == routeName) {
            return;
          }

          context.go(nextRoute);
        },
      ),
    );
  }
}

class _CardSearchField extends ConsumerStatefulWidget {
  const _CardSearchField();

  @override
  ConsumerState<_CardSearchField> createState() => _CardSearchFieldState();
}

class _CardSearchFieldState extends ConsumerState<_CardSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(cardSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final searchQuery = ref.watch(cardSearchQueryProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final hintStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.4),
    );
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: colorScheme.onSurface,
    );

    if (_controller.text != searchQuery) {
      _controller.value = TextEditingValue(
        text: searchQuery,
        selection: TextSelection.collapsed(offset: searchQuery.length),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          autofocus: false,
          onChanged: (value) {
            ref.read(cardSearchQueryProvider.notifier).setQuery(value);
          },
          style: textStyle,
          decoration: InputDecoration(
            hintText: l10n.searchByCardName,
            hintStyle: hintStyle,
            isDense: true,
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
            suffixIcon: searchQuery.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      _controller.clear();
                      ref.read(cardSearchQueryProvider.notifier).clear();
                    },
                    icon: Icon(
                      Icons.close,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: colorScheme.onSurface.withValues(alpha: 0.12),
        ),
      ],
    );
  }
}
