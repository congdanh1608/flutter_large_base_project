import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dt_digital_studio/core/config/app_constants.dart';

/// Thin wrapper around [FlutterSecureStorage] for token management.
class SecureStorageService {
  SecureStorageService._();

  static SecureStorageService? _instance;
  static SecureStorageService get instance {
    _instance ??= SecureStorageService._();
    return _instance!;
  }

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: AppConstants.keyAccessToken, value: accessToken),
      _storage.write(key: AppConstants.keyRefreshToken, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: AppConstants.keyAccessToken);

  Future<String?> getRefreshToken() => _storage.read(key: AppConstants.keyRefreshToken);

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: AppConstants.keyAccessToken),
      _storage.delete(key: AppConstants.keyRefreshToken),
    ]);
  }

  Future<void> clearAll() => _storage.deleteAll();
}
