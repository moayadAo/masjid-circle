// attendance_share_controller.dart
//
// Captures the full attendance table as a PNG image and shares it via
// the OS share sheet (WhatsApp, Telegram, etc.) using share_plus.
//
// How it works:
// 1. The table widget (AttendanceFullTableCapture) is mounted off-screen
//    inside the app's Overlay, wrapped in a RepaintBoundary.
// 2. Once a couple of frames have rendered, we read the RepaintBoundary's
//    RenderObject and convert it to a PNG byte buffer.
// 3. The PNG is written to a temp file and handed to share_plus.
// 4. The off-screen widget is removed from the Overlay right after.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import 'package:masjid/feature/attendance/widgets/attendance_share/attendance_full_table_capture.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AttendanceShareController {
  AttendanceShareController._();

  /// Renders [session]'s full table off-screen, captures it as a PNG,
  /// and opens the native share sheet. Returns false if capture failed.
  static Future<bool> captureAndShare({
    required BuildContext context,
    required AttendanceSessionModel session,
  }) async {
    final overlay = Overlay.of(context);
    final boundaryKey = GlobalKey();

    final entry = OverlayEntry(
      builder: (_) =>
          _OffstageCapture(boundaryKey: boundaryKey, session: session),
    );
    overlay.insert(entry);

    try {
      // Wait two frames: one to lay out + paint, one to make sure the
      // RepaintBoundary has a fully settled image ready to capture.
      await WidgetsBinding.instance.endOfFrame;
      await WidgetsBinding.instance.endOfFrame;

      final renderObject = boundaryKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) return false;

      final image = await renderObject.toImage(
        pixelRatio:
            2.0, // Capture a larger image for better quality when sharing.
        // Capture a larger image for better quality when sharing.
        // The default pixelRatio of 1.0 can produce a blurry image on high-res screens.
        // Adjust as needed based on testing across different devices.
      );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return false;

      final pngBytes = byteData.buffer.asUint8List();
      await _shareBytes(pngBytes, session: session);
      return true;
    } finally {
      entry.remove();
    }
  }

  static Future<void> _shareBytes(
    List<int> bytes, {
    required AttendanceSessionModel session,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = 'attendance_${session.id}_${session.date}.png';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'سجل الحضور - ${session.date}',
      ),
    );
  }
}

/// Invisible off-screen host for the capture widget. Positioned far
/// outside the viewport (rather than using Offstage) because Offstage
/// skips painting entirely, and RepaintBoundary needs a real paint pass
/// to produce pixels to capture.
class _OffstageCapture extends StatelessWidget {
  final GlobalKey boundaryKey;
  final AttendanceSessionModel session;

  const _OffstageCapture({required this.boundaryKey, required this.session});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -10000,
      top: 0,
      child: Material(
        color: Colors.transparent,
        child: RepaintBoundary(
          key: boundaryKey,
          child: AttendanceFullTableCapture(session: session),
        ),
      ),
    );
  }
}
