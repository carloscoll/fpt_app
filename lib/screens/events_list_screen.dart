// lib/screens/events_list_screen.dart
import 'package:flutter/material.dart';
import 'package:fpt_app/config.dart';
import 'package:fpt_app/widgets/event_card.dart';
import 'package:fpt_app/models/event.dart';

import '../services/event_service.dart';
import '../widgets/event_dialog.dart';

class PaginatedListEvents extends StatefulWidget {
  const PaginatedListEvents({super.key});

  @override
  _PaginatedListEventsState createState() => _PaginatedListEventsState();
}

class _PaginatedListEventsState extends State<PaginatedListEvents> {
  final ScrollController _scrollController = ScrollController();
  final List<Event> _items = [];

  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true; // Indica si quedan más eventos

  @override
  void initState() {
    super.initState();
    _loadMoreData();
    _scrollController.addListener(() {
      // Detectamos si hemos llegado al final de la lista
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        // Un umbral de 200 píxeles antes de llegar al final para evitar llamadas constantes
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (_isFetching) return;
    setState(() {
      _isFetching = true;
    });
    try {
      // Llamada a la API para obtener la página actual de eventos.
      final List<Event> fetchedEvents = await EventService(baseUrl: Config.BASE_URL)
          .fetchUpcomingEvents(_currentPage, Config.pageSize);

      // Si la lista devuelta está vacía o tiene menos elementos de los esperados,
      // asumimos que no hay más datos.
      if (fetchedEvents.isEmpty || fetchedEvents.length < Config.pageSize) {
        setState(() {
          _hasMore = false;
        });
      }

      // Si se obtuvieron eventos, los agregamos a la lista y actualizamos la página.
      if (fetchedEvents.isNotEmpty) {
        setState(() {
          _items.addAll(fetchedEvents);
          _currentPage++;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Eventos'),
      ),
      body: _items.isEmpty && _isFetching
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        itemCount: _hasMore ? _items.length + 1 : _items.length,
        itemBuilder: (context, index) {
          if (index < _items.length) {
            return EventCard(
                event: _items[index],
                onTap: () {
                 showDialog(
                     context: context,
                     builder: (context) => EventDialog(event: _items[index])
                 );
                });
          } else {
            // Este widget solo se muestra cuando _hasMore es true
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
