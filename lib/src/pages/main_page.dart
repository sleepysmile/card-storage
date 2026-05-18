import 'package:card_storage/src/providers/card_provider.dart';
import 'package:card_storage/src/routes/app_routes.dart';
import 'package:card_storage/src/widgets/app_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.title,
    required this.routeName,
    required this.child,
  });

  final String title;
  final String routeName;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final currentIndex = AppRoutes.indexFor(routeName);
    final currentTitle = AppRoutes.titleFor(routeName);
    final isHomeRoute = routeName == AppRoutes.home;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isHomeRoute ? 0 : kToolbarHeight,
        title: isHomeRoute ? null : Text('$title - $currentTitle'),
        bottom: isHomeRoute
            ? const PreferredSize(
                preferredSize: Size.fromHeight(56),
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
    final searchQuery = ref.watch(cardSearchQueryProvider);
    const darkIconColor = Color(0xDD000000);
    final colorScheme = Theme.of(context).colorScheme;
    final hintStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant);
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface);

    if (_controller.text != searchQuery) {
      _controller.value = TextEditingValue(
        text: searchQuery,
        selection: TextSelection.collapsed(offset: searchQuery.length),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          ref.read(cardSearchQueryProvider.notifier).setQuery(value);
        },
        style: textStyle,
        decoration: InputDecoration(
          hintText: 'Поиск по названию карты',
          hintStyle: hintStyle,
          isDense: true,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          prefixIcon: const Icon(Icons.search, color: darkIconColor),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          suffixIcon: searchQuery.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _controller.clear();
                    ref.read(cardSearchQueryProvider.notifier).clear();
                  },
                  icon: const Icon(Icons.close, color: darkIconColor),
                ),
        ),
      ),
    );
  }
}
