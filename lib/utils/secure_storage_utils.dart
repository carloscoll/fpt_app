// lib/utils/secure_storage_utils.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await secureStorage.write(key: 'token', value: token);
}

Future<String?> readToken() async {
  return await secureStorage.read(key: 'token');
}

Future<void> deleteToken() async {
  await secureStorage.delete(key: 'token');
}
