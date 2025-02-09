// lib/services/token_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Guarda el token de forma segura.
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  /// Lee el token guardado.
  Future<String?> readToken() async {
    return await _secureStorage.read(key: 'token');
  }

  /// Borra el token (por ejemplo, al cerrar sesión).
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'token');
  }
}
