// lib/models/event.dart
class Event {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String shortDescription;
  final DateTime date;

  Event({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.shortDescription,
    required this.date,
  });

  /// Método de fábrica para construir un objeto Event a partir de un JSON.
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      imageUrl: json['image_url'] ?? "",  // Se usa un valor por defecto si no existe la clave
      title: json['name'] as String,      // Suponiendo que el título viene en la clave 'name'
      description: json['description'] as String,
      shortDescription: json['short_description'] ?? json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  /// Método para convertir un objeto Event a JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'name': title,
      'description': description,
      'short_description': shortDescription,
      'date': date.toIso8601String(),
    };
  }
}
