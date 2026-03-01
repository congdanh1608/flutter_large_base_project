import 'package:dt_digital_studio/features/auth/screen/login_screen.dart';
import 'package:dt_digital_studio/features/splash/screen/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dt_digital_studio/core/router/route_names.dart';
import 'package:dt_digital_studio/features/home/screen/home_screen.dart';
import 'package:dt_digital_studio/shared/widgets/not_found_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});

/// Central GoRouter configuration.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.homeName,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
