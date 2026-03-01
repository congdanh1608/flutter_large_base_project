/// All route path strings and their named identifiers.
/// Use named routing exclusively: `context.goNamed(RouteNames.home)`
abstract final class RouteNames {
  // Paths
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';

  // Names (used with goNamed / pushNamed)
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String homeName = 'home';
}
