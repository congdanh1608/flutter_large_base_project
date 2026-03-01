/// Application flavor / environment configuration.
///
/// Usage: pass `--dart-define=FLAVOR=dev` (or staging / prod) when running.
///   flutter run --dart-define=FLAVOR=dev
///   flutter run --dart-define=FLAVOR=staging
///   flutter run --dart-define=FLAVOR=prod
enum AppFlavor { dev, staging, prod }

// ---- Model ------------------------------------------------------------------

/// Holds all environment-specific values for one flavor.
class FlavorModel {
  const FlavorModel({
    required this.flavor,
    required this.baseUrl,
    required this.appName,
    required this.enableLogging,
  });

  final AppFlavor flavor;
  final String baseUrl;
  final String appName;
  final bool enableLogging;

  @override
  String toString() =>
      'FlavorModel(flavor: ${flavor.name}, appName: $appName, baseUrl: $baseUrl)';
}

// ---- Config -----------------------------------------------------------------

/// Reads the compile-time `FLAVOR` constant and exposes the matching [FlavorModel].
abstract final class FlavorConfig {
  static const _flavorStr =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  /// The active [FlavorModel] for this build.
  static FlavorModel get current => switch (_flavor) {
        AppFlavor.dev => const FlavorModel(
            flavor: AppFlavor.dev,
            baseUrl: 'https://dev-api.dtdigitalstudio.com',
            appName: '[DEV] DTDigitalStudio',
            enableLogging: true,
          ),
        AppFlavor.staging => const FlavorModel(
            flavor: AppFlavor.staging,
            baseUrl: 'https://staging-api.dtdigitalstudio.com',
            appName: '[STAGING] DTDigitalStudio',
            enableLogging: true,
          ),
        AppFlavor.prod => const FlavorModel(
            flavor: AppFlavor.prod,
            baseUrl: 'https://api.dtdigitalstudio.com',
            appName: 'DTDigitalStudio',
            enableLogging: false,
          ),
      };

  // ---- Convenience getters --------------------------------------------------

  static AppFlavor get flavor => _flavor;
  static String get baseUrl => current.baseUrl;
  static String get appName => current.appName;
  static bool get enableLogging => current.enableLogging;

  static bool get isDev => _flavor == AppFlavor.dev;
  static bool get isStaging => _flavor == AppFlavor.staging;
  static bool get isProd => _flavor == AppFlavor.prod;

  // ---- Private helpers ------------------------------------------------------

  static final AppFlavor _flavor = AppFlavor.values.firstWhere(
    (e) => e.name == _flavorStr,
    orElse: () => AppFlavor.dev,
  );
}
