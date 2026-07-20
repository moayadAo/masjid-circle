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
    bool includeStudentDetails = false,
  }) async {
    final recordSlices = _splitRecords(session.sortedRecords);
    final overlay = Overlay.of(context);
    final boundaryKeys = List.generate(recordSlices.length, (_) => GlobalKey());

    final entry = OverlayEntry(
      builder: (_) => _OffstageCaptureBatch(
        boundaryKeys: boundaryKeys,
        session: session,
        recordSlices: recordSlices,
      ),
    );
    overlay.insert(entry);

    try {
      // Wait two frames: one to lay out + paint, one to make sure the
      // RepaintBoundary has a fully settled image ready to capture.
      await WidgetsBinding.instance.endOfFrame;
      await WidgetsBinding.instance.endOfFrame;

      final files = <File>[];
      for (var index = 0; index < boundaryKeys.length; index++) {
        final renderObject = boundaryKeys[index].currentContext
            ?.findRenderObject();
        if (renderObject is! RenderRepaintBoundary) return false;

        final image = await renderObject.toImage(pixelRatio: 2.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) return false;

        files.add(
          await _writeTempImage(
            byteData.buffer.asUint8List(),
            session: session,
            pageIndex: index + 1,
          ),
        );
      }

      await _shareFiles(
        files,
        session: session,
        includeStudentDetails: includeStudentDetails,
      );
      return true;
    } finally {
      entry.remove();
    }
  }

  static List<List<AttendanceRecordModel>> _splitRecords(
    List<AttendanceRecordModel> records,
  ) {
    if (records.length <= 15) {
      return [records];
    }

    final firstPageCount = (records.length / 2).ceil();
    return [
      records.sublist(0, firstPageCount),
      records.sublist(firstPageCount),
    ];
  }

  static Future<File> _writeTempImage(
    List<int> bytes, {
    required AttendanceSessionModel session,
    required int pageIndex,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = 'attendance_${session.id}_${session.date}_p$pageIndex.png';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }

  static Future<void> _shareFiles(
    List<File> files, {
    required AttendanceSessionModel session,
    bool includeStudentDetails = false,
  }) async {
    String messageText = 'سجل الحضور - ${session.date}';

    if (includeStudentDetails) {
      final recordsText = session.sortedRecords
          .map(
            (record) =>
                '${record.student.fullName}: ${_getArabicStatus(record.status)}',
          )
          .join('\n');
      messageText = 'سجل الحضور - ${session.date}\n\n$recordsText';
    }

    await SharePlus.instance.share(
      ShareParams(
        files: files.map((file) => XFile(file.path)).toList(),
        text: messageText,
      ),
    );
  }

  static String _getArabicStatus(String status) {
    return switch (status) {
      'present' => 'حاضر ✅',
      'late' => 'متأخر 🕒',
      'absent' => 'غائب ❌',
      'excused' => 'غياب مبرر 📝',
      _ => status,
    };
  }
}

/// Invisible off-screen host for the capture widget. Positioned far
/// outside the viewport (rather than using Offstage) because Offstage
/// skips painting entirely, and RepaintBoundary needs a real paint pass
/// to produce pixels to capture.
class _OffstageCapture extends StatelessWidget {
  final GlobalKey boundaryKey;
  final AttendanceSessionModel session;
  final List<AttendanceRecordModel>? records;

  const _OffstageCapture({
    required this.boundaryKey,
    required this.session,
    this.records,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -10000,
      top: 0,
      child: Material(
        color: Colors.transparent,
        child: RepaintBoundary(
          key: boundaryKey,
          child: AttendanceFullTableCapture(session: session, records: records),
        ),
      ),
    );
  }
}

class _OffstageCaptureBatch extends StatelessWidget {
  final List<GlobalKey> boundaryKeys;
  final AttendanceSessionModel session;
  final List<List<AttendanceRecordModel>> recordSlices;

  const _OffstageCaptureBatch({
    required this.boundaryKeys,
    required this.session,
    required this.recordSlices,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var index = 0; index < recordSlices.length; index++)
          Positioned(
            left: -10000,
            top: index * 2000,
            child: _OffstageCapture(
              boundaryKey: boundaryKeys[index],
              session: session,
              records: recordSlices[index],
            ),
          ),
      ],
    );
  }
}
