// lib/services/event_service.dart
import 'dart:convert';
import 'package:fpt_app/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:fpt_app/models/event.dart';

class EventService {
  final String baseUrl;
  final TokenService tokenService = TokenService();
  EventService({required this.baseUrl});

  /// Obtiene la lista de eventos para un rango de fechas dado.
  Future<List<Event>> fetchEvents(DateTime start, DateTime end) async {
    final String startStr = start.toIso8601String();
    final String endStr = end.toIso8601String();

    final response = await http.get(
      Uri.parse('$baseUrl/events?start=$startStr&end=$endStr'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonData = jsonResponse['data'];

      return jsonData.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar eventos');
    }
  }

  /// Carga los eventos de la API para la página indicada.
  Future<List<Event>> fetchUpcomingEvents(int page, int pageSize) async {
    final token = await tokenService.readToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(Uri.parse("$baseUrl/events/upcoming?page="
        "$page&page_size=$pageSize"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
        final List<dynamic> jsonData = jsonResponse['data'];
        return jsonData.map((e) => Event.fromJson(e)).toList();
      } else {
        throw Exception("No se encontró la clave 'data' en la respuesta JSON");
      }
    } else {
      throw Exception('Error al cargar eventos');
    }
  }

  /// Llama al endpoint /subscribe para apuntarse a un evento.
  Future<void> subscribeEvent(String userId, String eventId) async {
    final token = await tokenService.readToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final body = jsonEncode({
      'user_id': userId,
      'event_id': eventId,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/subscriptions/subscribe'),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 201) {
      throw Exception('Error al apuntarse al evento');
    }
  }
}
