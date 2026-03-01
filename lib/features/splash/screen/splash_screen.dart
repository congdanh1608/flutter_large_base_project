import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dt_digital_studio/core/router/route_names.dart';

import '../../auth/provider/auth_provider.dart';

/// Splash screen — shows briefly while the app initialises and determines navigation target.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  /// True once the minimum splash duration has elapsed.
  bool _minDurationPassed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    Future<void>.delayed(const Duration(milliseconds: 1800)).then((_) {
      if (!mounted) return;
      _minDurationPassed = true;
      _maybeNavigate();
    });
  }

  /// Navigates only when BOTH the minimum splash duration has passed AND
  /// the auth check has finished. This prevents a race condition where a
  /// slow API response causes an authenticated user to be sent to login.
  void _maybeNavigate() {
    if (!mounted || !_minDurationPassed) return;
    final authState = ref.read(authNotifierProvider);
    if (authState.isLoading) return; // auth check still in flight
    if (authState.isAuthenticated) {
      context.goNamed(RouteNames.homeName);
    } else {
      context.goNamed(RouteNames.loginName);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // React to auth state changes so navigation fires as soon as auth is
    // ready, even if the API responds after the 1800 ms timer.
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (!next.isLoading) _maybeNavigate();
    });

    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child:
                    const Icon(Icons.diamond_outlined, color: Colors.white, size: 44),
              ),
              const SizedBox(height: 20),
              Text(
                'DTDigitalStudio',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
