// lib/screens/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fpt_app/models/event.dart';
import 'package:fpt_app/services/event_service.dart';
import 'package:fpt_app/config.dart';
import 'package:fpt_app/widgets/event_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Día enfocado y seleccionado para TableCalendar.
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Mapa para agrupar los eventos por día.
  // La clave será una fecha sin horas.
  Map<DateTime, List<Event>> _events = {};

  final EventService _eventService = EventService(baseUrl: Config.BASE_URL);

  @override
  void initState() {
    super.initState();
    _loadEventsForMonth(_focusedDay);
  }

  /// Devuelve la fecha sin horas (año, mes y día) para usarla como clave.
  DateTime _getDateKey(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Carga los eventos para el mes del día enfocado y agrupa los eventos por día.
  Future<void> _loadEventsForMonth(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);
    try {
      List<Event> events = await _eventService.fetchEvents(start, end);
      final Map<DateTime, List<Event>> eventMap = {};
      for (final event in events) {
        final dateKey = _getDateKey(event.date);
        if (eventMap[dateKey] == null) {
          eventMap[dateKey] = [];
        }
        eventMap[dateKey]!.add(event);
      }
      setState(() {
        _events = eventMap;
      });
    } catch (e) {
      print("Error al cargar eventos: $e");
    }
  }

  /// Función para obtener la lista de eventos para un día determinado.
  List<Event> _getEventsForDay(DateTime day) {
    return _events[_getDateKey(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendario de Eventos"),
      ),
      body: Column(
        children: [
          // Parte superior: TableCalendar
          TableCalendar(
            locale: 'es_ES',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            eventLoader: _getEventsForDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false, // Oculta el botón de cambio de formato
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              defaultDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade100),
                  shape: BoxShape.rectangle
              ),
              todayDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.blue.shade100, // Fondo naranja con opacidad
              ),
              selectedDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.blue, width: 2),
                color: Colors.orange.shade700,
              ),
              weekendDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              weekendTextStyle: TextStyle(
                color: Colors.amber
              ),
              outsideDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _loadEventsForMonth(focusedDay);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return const SizedBox();
                return Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      events.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          // Parte inferior: Lista de EventCards para el día seleccionado.
          Expanded(
            child: _getEventsForDay(_selectedDay).isEmpty
                ? const Center(
              child: Text("No hay eventos para el día seleccionado"),
            )
                : ListView.builder(
              itemCount: _getEventsForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay)[index];
                return EventCard(event: event);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Función auxiliar para determinar si dos fechas son el mismo día.
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
