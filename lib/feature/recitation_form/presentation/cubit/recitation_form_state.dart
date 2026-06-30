// recitation_form_state.dart

import '../../data/models/recitation_model.dart';
import '../../data/models/surah_model.dart';

/// Which tab of the recitation form is active.
enum RecitationFormTab { pages, surah }

/// The 3 possible ratings a teacher can give.
enum RecitationRating { good, veryGood, excellent }

extension RecitationRatingApi on RecitationRating {
  /// Value expected by the API (`good` | `very_good` | `excellent`).
  String get apiValue {
    switch (this) {
      case RecitationRating.good:
        return 'good';
      case RecitationRating.veryGood:
        return 'very_good';
      case RecitationRating.excellent:
        return 'excellent';
    }
  }
}

/// Status of the "create recitation" submission.
enum RecitationSubmissionStatus { idle, loading, success, failure }

class RecitationFormState {
  final RecitationFormTab selectedTab;

  // Pages tab
  final int fromPage;
  final int toPage;

  // Surah tab
  final SurahModel? selectedSurah;

  // Rating
  final RecitationRating? rating;

  // Submission
  final RecitationSubmissionStatus submissionStatus;
  final String? errorMessage;
  final RecitationModel? result;

  const RecitationFormState({
    this.selectedTab = RecitationFormTab.pages,
    this.fromPage = 1,
    this.toPage = 1,
    this.selectedSurah,
    this.rating,
    this.submissionStatus = RecitationSubmissionStatus.idle,
    this.errorMessage,
    this.result,
  });

  bool get canSubmit {
    final hasContent = selectedTab == RecitationFormTab.pages
        ? toPage >= fromPage
        : selectedSurah != null;

    return hasContent &&
        rating != null &&
        submissionStatus != RecitationSubmissionStatus.loading;
  }

  RecitationFormState copyWith({
    RecitationFormTab? selectedTab,
    int? fromPage,
    int? toPage,
    SurahModel? selectedSurah,
    RecitationRating? rating,
  }) {
    return RecitationFormState(
      selectedTab: selectedTab ?? this.selectedTab,
      fromPage: fromPage ?? this.fromPage,
      toPage: toPage ?? this.toPage,
      selectedSurah: selectedSurah ?? this.selectedSurah,
      rating: rating ?? this.rating,
      // ✅ Always reset on any form interaction —
      //    prevents stale failure state from re-triggering the listener.
      submissionStatus: RecitationSubmissionStatus.idle,
      errorMessage: null,
      result: null,

      // submissionStatus: submissionStatus,
      // errorMessage: errorMessage,
      // result: result,
    );
  }

  /// Returns a copy with the submission status updated, keeping all
  /// form fields as they are.
  RecitationFormState withStatus({
    required RecitationSubmissionStatus status,
    String? errorMessage,
    RecitationModel? result,
  }) {
    return RecitationFormState(
      selectedTab: selectedTab,
      fromPage: fromPage,
      toPage: toPage,
      selectedSurah: selectedSurah,
      rating: rating,
      submissionStatus: status,
      errorMessage: errorMessage,
      result: result,
    );
  }
}
