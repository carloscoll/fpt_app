// lib/widgets/qr_dialog.dart
import 'package:flutter/material.dart';
import 'package:fpt_app/config.dart';
import 'package:fpt_app/screens/login_screen.dart';
import 'package:fpt_app/services/user_service.dart';
import 'package:fpt_app/widgets/qr_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDialog extends StatefulWidget {
  const QrDialog({Key? key}) : super(key: key);

  @override
  _QrDialogState createState() => _QrDialogState();
}

class _QrDialogState extends State<QrDialog> {
  final UserService _userService = UserService(baseUrl: Config.BASE_URL);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Lógica para escanear QR
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      height: 400,
                      width: 600,
                      padding: const EdgeInsets.all(16),
                      child: QrScannerWidget(
                        onScanSuccess: (String? code) {
                          _userService.consumeDrink(code).then((response) {
                            // Procesa la respuesta si es necesario
                          }).catchError((error) {
                            if (error is SessionExpiredException) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            }
                          });
                          Navigator.of(context).pop(code);
                        },
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.qr_code_scanner,
                size: 32, // Tamaño mayor para el ícono
              ),
              label: const Text(
                'Escanear',
                style: TextStyle(fontSize: 20), // Fuente más grande
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Lógica para generar QR
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: 320,
                        height: 320,
                        padding: const EdgeInsets.all(16),
                        child: FutureBuilder<String>(
                          future: _userService.createQrCodeData(),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              if (snapshot.error is SessionExpiredException) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginScreen()),
                                  );
                                });
                                return Container();
                              }
                              return const Center(
                                  child: Text(
                                    '¡Vaya! Algo ha salido mal...',
                                    textAlign: TextAlign.center,
                                  ));
                            } else if (snapshot.hasData) {
                              return QrImageView(
                                data: snapshot.data!,
                                version: QrVersions.auto,
                                gapless: false,
                                errorStateBuilder: (cxt, err) {
                                  return const Center(
                                    child: Text(
                                      '¡Vaya! Algo ha salido mal...',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(child: Text("No hay datos QR disponibles"));
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.qr_code,
                size: 32, // Ícono más grande
              ),
              label: const Text(
                'Generar',
                style: TextStyle(fontSize: 20), // Fuente más grande
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).colorScheme.secondary, size: 28),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
