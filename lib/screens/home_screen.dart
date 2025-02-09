// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:fpt_app/screens/events_list_screen.dart';
import 'package:fpt_app/screens/calendar_screen.dart';
import 'package:fpt_app/screens/user_screen.dart';
import 'package:fpt_app/widgets/qr_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const PaginatedListEvents(), // Pantalla de eventos
    const CalendarScreen(),      // Pantalla de calendario
    const UserInfoWidget(),      // Pantalla de información de usuario
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      floatingActionButton: SizedBox(
        height: 100.0,
        width: 100.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => const QrDialog(),
              );
            },
            tooltip: 'Show QR dialog',
            child: Icon(
              Icons.qr_code_2_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 40,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 35),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded, size: 35),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded, size: 35),
            label: 'Usuario',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
