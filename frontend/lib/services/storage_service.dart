import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: AppConfig.accessTokenKey, value: accessToken);
    await _storage.write(key: AppConfig.refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() =>
      _storage.read(key: AppConfig.accessTokenKey);

  Future<String?> getRefreshToken() =>
      _storage.read(key: AppConfig.refreshTokenKey);

  Future<bool> hasToken() async {
    final token = await _storage.read(key: AppConfig.accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<void> clear() => _storage.deleteAll();
}
