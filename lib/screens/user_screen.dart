// lib/screens/user_screen.dart
import 'package:flutter/material.dart';
import 'package:fpt_app/screens/login_screen.dart';
import 'package:fpt_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fpt_app/config.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  final UserService _userService =
  UserService(baseUrl: Config.BASE_URL); // Actualiza la URL base

  Future<String> obtainUserName() async {
    try {
      final user = await _userService.getUser();
      return '${user.name} ${user.surnames}';
    } catch (e) {
      return '';
    }
  }

  Future<int> obtainUserDrinks() async {
    try {
      final user = await _userService.getUser();
      return user.drinks;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Información del Usuario"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card para mostrar el nombre del usuario.
            FutureBuilder<String>(
              future: obtainUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == '') {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Error al obtener datos del usuario.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                } else {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, size: 40),
                      title: Text(
                        snapshot.data!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            // Sección para los eventos apuntados (podrías usar un título estilizado)
            const Text(
              "Eventos Apuntados:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Aquí podrías agregar una lista de eventos (si tienes datos de eventos)
            // Por el momento solo mostramos un placeholder.
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Aquí se mostrarán los eventos a los que estás apuntado.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Card para el número de bebidas.
            FutureBuilder<int>(
              future: obtainUserDrinks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Error al obtener datos.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                } else {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.local_drink, size: 40),
                      title: Text(
                        "Número de Bebidas: ${snapshot.data}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 30),
            // Botón para cerrar sesión
            ElevatedButton.icon(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary
              ),
              icon: const Icon(Icons.exit_to_app),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
