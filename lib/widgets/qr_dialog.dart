// lib/widgets/qr_dialog.dart
import 'package:flutter/material.dart';
import 'package:fpt_app/services/api_service.dart';
import 'package:fpt_app/config.dart';
import 'package:fpt_app/screens/login_screen.dart';
import 'package:fpt_app/widgets/qr_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDialog extends StatefulWidget {
  const QrDialog({super.key});
  @override
  _QrDialogState createState() => _QrDialogState();
}

class _QrDialogState extends State<QrDialog> {
  final ApiService _apiService = ApiService(baseUrl: Config.BASE_URL);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      children: <Widget>[
        Column(
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Container(
                    alignment: Alignment.center,
                    child: Container(
                      height: 400,
                      width: 600,
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: QrScannerWidget(
                                onScanSuccess: (String? code) {
                                  _apiService.consumeDrink(code).then((response) {
                                    // Procesa la respuesta si es necesario
                                  }).catchError((error) {
                                    if (error is SessionExpiredException) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                                      );
                                    }
                                  });
                                  Navigator.of(context).pop(code);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Text(
                'ESCANEAR',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Divider(color: Colors.black45, thickness: 1),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      children: [
                        SizedBox(
                          width: 320,
                          height: 320,
                          child: FutureBuilder<String>(
                            future: _apiService.createQrCodeData(),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                if (snapshot.error is SessionExpiredException) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                                    );
                                  });
                                  return Container();
                                }
                                return const Center(child: Text('Uh oh! Something went wrong...', textAlign: TextAlign.center));
                              } else if (snapshot.hasData) {
                                return QrImageView(
                                  data: snapshot.data!,
                                  version: QrVersions.auto,
                                  gapless: false,
                                  errorStateBuilder: (cxt, err) {
                                    return const Center(child: Text('Uh oh! Something went wrong...', textAlign: TextAlign.center));
                                  },
                                );
                              } else {
                                return const Center(child: Text("No QR data available"));
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'GENERAR',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
