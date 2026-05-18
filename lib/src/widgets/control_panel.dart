import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({
    super.key,
    required this.onAddCardPressed,
  });

  final VoidCallback onAddCardPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 148,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: IconButton.filled(
                          onPressed: onAddCardPressed,
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: IconButton.outlined(
                          onPressed: null,
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  children: const [
                    Expanded(
                      child: _ControlPanelPlaceholder(
                        title: 'Свободная строка 1',
                      ),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: _ControlPanelPlaceholder(
                        title: 'Свободная строка 2',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlPanelPlaceholder extends StatelessWidget {
  const _ControlPanelPlaceholder({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
