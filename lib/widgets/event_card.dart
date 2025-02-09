import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fpt_app/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap; // Callback opcional para manejar el tap

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        // El InkWell usará la sombra y forma del Card, y permitirá el efecto "splash"
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Puedes usar un Image.network o Image.asset, según tu fuente
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: (event.imageUrl.trim().isEmpty)
                  ? Container(
                height: 180,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.event,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              )
                  : Image.asset(
                event.imageUrl,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                event.title,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                DateFormat("dd/MM/yyyy").format(event.date),
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                event.shortDescription,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
