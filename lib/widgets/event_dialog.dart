import 'package:flutter/material.dart';
import 'package:fpt_app/models/event.dart';

class EventDialog extends StatelessWidget {
  final Event event;

  const EventDialog({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(event.title),
      content: SingleChildScrollView(
        child: Text(event.description),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          child: Text(
            "APUNTARSE",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () async {
            // Aquí iría la lógica para apuntarse al evento
            // Por ejemplo, llamar a un servicio y mostrar un SnackBar
            Navigator.of(context).pop(); // Cierra el diálogo
          },
        ),
        TextButton(
          child: const Text("Cerrar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
