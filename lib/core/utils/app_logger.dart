import 'package:logger/logger.dart';
import 'package:dt_digital_studio/core/config/app_flavor.dart';

/// Central application logger.
///
/// Usage:
/// ```dart
/// AppLogger.debug('Loading user data');
/// AppLogger.error('Failed to fetch', error, stackTrace);
/// AppLogger.network('POST /auth/login');
/// ```
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    level: FlavorConfig.enableLogging ? Level.trace : Level.off,
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  static void trace(dynamic message) => _logger.t(message);
  static void debug(dynamic message) => _logger.d(message);
  static void info(dynamic message) => _logger.i(message);
  static void warning(dynamic message) => _logger.w(message);
  static void error(dynamic message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  static void network(dynamic message) => _logger.d('[NET] $message');
}
