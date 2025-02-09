// lib/models/user.dart
class User {
  final String id;
  final String name;
  final String surnames;
  final int drinks;
  // Puedes agregar más propiedades según tu API

  User({
    required this.id,
    required this.name,
    required this.surnames,
    required this.drinks,
  });

  // Método de fábrica para construir un User a partir de JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      surnames: json['surnames'] as String,
      drinks: json['drinks'] as int,
    );
  }

  // Opcional: método para convertir un User a JSON, si lo necesitas
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surnames': surnames,
      'drinks': drinks,
    };
  }
}
