// lib/services/user_service.dart
import 'dart:convert';
import 'package:fpt_app/services/token_service.dart';
import 'package:fpt_app/utils/secure_storage_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fpt_app/models/user.dart';

class UserService {
  final String baseUrl;
  final TokenService tokenService = TokenService();

  UserService({required this.baseUrl});

  /// Obtiene los datos del usuario autenticado y devuelve un objeto [User].
  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await tokenService.readToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.get(
      Uri.parse('$baseUrl/users/${prefs.getString('id')}'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> userJson = jsonDecode(response.body);
      return User.fromJson(userJson);
    } else if (response.statusCode == 401) {
      throw SessionExpiredException();
    } else {
      throw Exception('Error al obtener el usuario');
    }
  }

  /// Realiza el login y almacena el token y otros datos en SharedPreferences.
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await tokenService.saveToken(data['token']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('id', data['id']);
    } else {
      throw Exception('Error de inicio de sesión');
    }
  }

  /// Consume bebida (u otra acción) utilizando un código QR.
  Future<http.Response> consumeDrink(String? code) async {
    User currentUser = await getUser();
    final consumptionData = jsonDecode(code!);
    final token = await tokenService.readToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final datetime = getUTCTimeWithZone();
    final response = await http.post(
      Uri.parse('$baseUrl/drinks/consume'),
      headers: headers,
      body: jsonEncode(<String, String>{
        'consumption_user_id': consumptionData['id'],
        'reader_user_id': currentUser.id,
        'drinks': consumptionData['drinks'].toString(),
        'consumption_datetime': datetime,
      }),
    );
    if (response.statusCode == 401) {
      throw SessionExpiredException();
    }
    return response;
  }
}

/// Excepción para cuando la sesión expira.
class SessionExpiredException implements Exception {}

/// Utilidad para obtener la fecha y hora actual en formato ISO8601 (UTC).
String getUTCTimeWithZone() {
  DateTime ahoraUTC = DateTime.now().toUtc();
  return ahoraUTC.toIso8601String();
}
