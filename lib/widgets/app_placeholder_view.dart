import 'package:flutter/material.dart';

class AppPlaceholderView extends StatelessWidget {
  const AppPlaceholderView({
    super.key,
    required this.title,
    this.todo,
  });

  final String title;
  final String? todo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(todo ?? 'Screen scaffold ready.'),
          ],
        ),
      ),
    );
  }
}
