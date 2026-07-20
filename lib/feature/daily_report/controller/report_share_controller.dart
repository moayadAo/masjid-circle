// report_share_controller.dart
//
// Splits the student list into chunks of [kStudentsPerPage] (10),
// renders each chunk as a ReportPageWidget off-screen via Overlay,
// captures each as a PNG, then shares all images together via share_plus.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:masjid/feature/daily_report/data/model/daily_report_model.dart';
import 'package:masjid/feature/daily_report/presentation/pages/report_page_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

const int kStudentsPerPage = 10;

class ReportShareController {
  ReportShareController._();

  static Future<bool> captureAndShare({
    required BuildContext context,
    required List<DailyReportStudentModel> students,
    required String reportDate,
    required String circleName,
    required bool showStudentsWithoutRecitation,
  }) async {
    final visibleStudents = showStudentsWithoutRecitation
        ? students
        : students.where((student) => !student.didNotReciteToday).toList();

    // Split students into pages of kStudentsPerPage
    final pages = _chunkStudents(visibleStudents);
    final totalPages = pages.length;
    final overlay = Overlay.of(context);
    final List<XFile> imageFiles = [];

    for (var pageIndex = 0; pageIndex < pages.length; pageIndex++) {
      final boundaryKey = GlobalKey();

      final entry = OverlayEntry(
        builder: (_) => _OffstageReportPage(
          boundaryKey: boundaryKey,
          students: pages[pageIndex],
          reportDate: reportDate,
          circleName: circleName,
          pageNumber: pageIndex + 1,
          totalPages: totalPages,
          totalStudents: visibleStudents.length,
        ),
      );

      overlay.insert(entry);

      // Two frames to guarantee full layout + paint pass
      await WidgetsBinding.instance.endOfFrame;
      await WidgetsBinding.instance.endOfFrame;

      try {
        final renderObject = boundaryKey.currentContext?.findRenderObject();
        if (renderObject is! RenderRepaintBoundary) {
          entry.remove();
          continue;
        }

        final image = await renderObject.toImage(pixelRatio: 2.5);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        entry.remove();

        if (byteData == null) continue;

        final file = await _savePng(
          bytes: byteData.buffer.asUint8List(),
          fileName: 'report_${reportDate}_page${pageIndex + 1}.png',
        );
        imageFiles.add(XFile(file.path));
      } catch (_) {
        entry.remove();
        rethrow;
      }
    }

    if (imageFiles.isEmpty) return false;

    await SharePlus.instance.share(
      ShareParams(
        files: imageFiles,
        text: 'تقرير التسميع اليومي – $reportDate',
      ),
    );
    return true;
  }

  static List<List<DailyReportStudentModel>> _chunkStudents(
    List<DailyReportStudentModel> students,
  ) {
    final chunks = <List<DailyReportStudentModel>>[];
    for (var i = 0; i < students.length; i += kStudentsPerPage) {
      final end = (i + kStudentsPerPage < students.length)
          ? i + kStudentsPerPage
          : students.length;
      chunks.add(students.sublist(i, end));
    }
    return chunks.isEmpty ? [[]] : chunks;
  }

  static Future<File> _savePng({
    required List<int> bytes,
    required String fileName,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

/// Invisible off-screen host for one report page.
/// Positioned far outside the visible viewport so it never shows on screen,
/// while still receiving a real paint pass (unlike Offstage).
class _OffstageReportPage extends StatelessWidget {
  final GlobalKey boundaryKey;
  final List<DailyReportStudentModel> students;
  final String reportDate;
  final String circleName;
  final int pageNumber;
  final int totalPages;
  final int totalStudents;

  const _OffstageReportPage({
    required this.boundaryKey,
    required this.students,
    required this.reportDate,
    required this.circleName,
    required this.pageNumber,
    required this.totalPages,
    required this.totalStudents,
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
          child: ReportPageWidget(
            students: students,
            reportDate: reportDate,
            circleName: circleName,
            pageNumber: pageNumber,
            totalPages: totalPages,
            totalStudents: totalStudents,
          ),
        ),
      ),
    );
  }
}
