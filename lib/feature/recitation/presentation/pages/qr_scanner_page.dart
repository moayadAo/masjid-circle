// qr_scanner_page.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

/// Simple full-screen QR scanner.
/// Pops with the scanned `public_code` once a valid code is detected.
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final barcode = capture.barcodes.firstOrNull;
    final value = barcode?.rawValue;
    if (value == null || value.isEmpty) return;

    _handled = true;
    Navigator.pop(context, value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text(
          'مسح رمز الطالب',
          style: AppTextStyle.headlineMd(context).copyWith(color: AppColor.onPrimary),
        ),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}

extension on List<Barcode> {
  Barcode? get firstOrNull => isEmpty ? null : first;
}
