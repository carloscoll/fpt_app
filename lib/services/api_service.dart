// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fpt_app/config.dart';

class ApiService {
  final String baseUrl;
  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
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
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw SessionExpiredException();
    } else {
      throw Exception('Error al obtener el usuario');
    }
  }

  Future<http.Response> consumeDrink(String? code) async {
    Map<String, dynamic> scannerUser = await getUser();
    var consumptionUser = jsonDecode(code!);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
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
        'consumption_user_id': consumptionUser['id'],
        'reader_user_id': scannerUser['id'],
        'drinks': consumptionUser['drinks'].toString(),
        'consumption_datetime': datetime,
      }),
    );
    if (response.statusCode == 401) {
      throw SessionExpiredException();
    }
    return response;
  }

  Future<String> createQrCodeData() async {
    try {
      final userMap = await getUser();
      var qrMap = {
        'id': userMap['id'],
        'drinks': userMap['drinks'],
      };
      return jsonEncode(qrMap);
    } on SessionExpiredException {
      throw SessionExpiredException();
    } catch (e) {
      return 'Error: Failed to create QR code';
    }
  }
}

class SessionExpiredException implements Exception {}

// Utilidad para obtener la fecha y hora UTC con formato
String getUTCTimeWithZone() {
  DateTime ahoraUTC = DateTime.now().toUtc();
  return ahoraUTC.toIso8601String();
}
