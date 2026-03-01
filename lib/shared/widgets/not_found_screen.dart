import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dt_digital_studio/core/router/route_names.dart';

/// Shown when navigating to an unknown route (GoRouter errorBuilder).
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('404', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 8),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.goNamed(RouteNames.homeName),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
