// qr_scanner_page.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/app_toast/app_toast.dart';
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

  void _handleScanResult(String? value) {
    if (_handled) return;

    final code = value?.trim();
    if (code == null || code.isEmpty) {
      if (mounted) {
        AppToast.warning(context, 'لم يتم قراءة أي رمز QR، حاول مرة أخرى');
      }
      return;
    }

    _handled = true;
    Navigator.pop(context, code);
  }

  void _onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.firstOrNull;
    _handleScanResult(barcode?.rawValue);
  }

  void _onClosePressed() {
    if (_handled) return;

    _handled = true;
    Navigator.pop(context, null);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        if (!_handled) {
          _handled = true;
          Navigator.pop(context, null);
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primary,
        appBar: AppBar(
          backgroundColor: AppColor.primary,
          leading: IconButton(
            onPressed: _onClosePressed,
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColor.onPrimary,
          ),
          title: Text(
            'مسح رمز الطالب',
            style: AppTextStyle.headlineMd(
              context,
            ).copyWith(color: AppColor.onPrimary),
          ),
        ),
        body: MobileScanner(controller: _controller, onDetect: _onDetect),
      ),
    );
  }
}

extension on List<Barcode> {
  Barcode? get firstOrNull => isEmpty ? null : first;
}
