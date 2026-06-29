// recitation_form_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/recitation_form/presentation/cubit/recitation_form_state.dart';

import '../../../recitation_form/data/remote/recitation_form_service.dart';
import '../../data/models/surah_model.dart';

class RecitationFormCubit extends Cubit<RecitationFormState> {
  final RecitationFormService recitationService;

  static const int _minPage = 1;
  static const int _maxPage =
      604; // Adjust to your preferred max boundary if higher

  RecitationFormCubit({required this.recitationService})
    : super(const RecitationFormState());

  // ── Tabs ────────────────────────────────────────────────────────────────

  void changeTab(RecitationFormTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  // ── Pages counters ─────────────────────────────────────────────────────

  void incrementFromPage() {
    final next = (state.fromPage + 1).clamp(_minPage, _maxPage);
    emit(state.copyWith(fromPage: next));
  }

  void decrementFromPage() {
    final next = (state.fromPage - 1).clamp(_minPage, _maxPage);
    emit(state.copyWith(fromPage: next));
  }

  void incrementToPage() {
    final next = (state.toPage + 1).clamp(_minPage, _maxPage);
    emit(state.copyWith(toPage: next));
  }

  void decrementToPage() {
    final next = (state.toPage - 1).clamp(_minPage, _maxPage);
    emit(state.copyWith(toPage: next));
  }

  // New: Handle manual input typing updates safely
  void updateFromPage(int value) {
    final target = value.clamp(_minPage, _maxPage);
    emit(state.copyWith(fromPage: target));
  }

  // New: Handle manual input typing updates safely
  void updateToPage(int value) {
    final target = value.clamp(_minPage, _maxPage);
    emit(state.copyWith(toPage: target));
  }

  // ── Surah ───────────────────────────────────────────────────────────────

  void selectSurah(SurahModel surah) {
    emit(state.copyWith(selectedSurah: surah));
  }

  // ── Rating ──────────────────────────────────────────────────────────────

  void selectRating(RecitationRating rating) {
    emit(state.copyWith(rating: rating));
  }

  // ── Submit ──────────────────────────────────────────────────────────────

  Future<void> submit({
    required int cycleId,
    required int circleId,
    required int studentId,
    required String recitedAt,
    String? notes,
  }) async {
    if (!state.canSubmit) return;

    emit(state.withStatus(status: RecitationSubmissionStatus.loading));

    final isPages = state.selectedTab == RecitationFormTab.pages;

    final response = await recitationService.createRecitation(
      cycleId: cycleId,
      circleId: circleId,
      studentId: studentId,
      recitationType: isPages ? 'pages' : 'surah',
      rating: state.rating!.apiValue,
      recitedAt: recitedAt,
      fromPage: isPages ? state.fromPage : null,
      toPage: isPages ? state.toPage : null,
      pagesCount: isPages ? (state.toPage - state.fromPage + 1) : null,
      surahId: isPages ? null : state.selectedSurah!.id,
      notes: (notes == null || notes.trim().isEmpty) ? null : notes.trim(),
    );

    response.fold(
      (errMessage) => emit(
        state.withStatus(
          status: RecitationSubmissionStatus.failure,
          errorMessage: errMessage,
        ),
      ),
      (result) => emit(
        state.withStatus(
          status: RecitationSubmissionStatus.success,
          result: result,
        ),
      ),
    );
  }
}
