// lib/widgets/qr_scanner.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrScannerWidget extends StatefulWidget {
  final void Function(String? code) onScanSuccess;
  const QrScannerWidget({super.key, required this.onScanSuccess});

  @override
  _QrScannerWidgetState createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> with WidgetsBindingObserver {
  MobileScannerController controller = MobileScannerController();
  bool isScanned = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null) return;
    if (state == AppLifecycleState.inactive) {
      controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      controller.start();
    }
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        _showPermissionDeniedDialog();
        return;
      }
    }
    controller.start();
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permiso Requerido"),
        content: const Text("Se necesita acceso a la cámara para escanear códigos QR."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text("Abrir Ajustes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (barcodeCapture) {
        if (!isScanned && barcodeCapture.barcodes.isNotEmpty) {
          final barcode = barcodeCapture.barcodes.first;
          if (barcode.rawValue != null) {
            setState(() {
              isScanned = true;
            });
            widget.onScanSuccess(barcode.rawValue);
            controller.stop();
          }
        }
      },
    );
  }
}

/// Función opcional para mostrar el escáner en un diálogo modal
void showQrScannerDialog(BuildContext context, void Function(String? code) onScanSuccess) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: QrScannerWidget(onScanSuccess: (code) {
                onScanSuccess(code);
                Navigator.pop(context);
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cerrar"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
