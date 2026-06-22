// // circle_recitations_state.dart

// import 'package:masjid/feature/circles/data_source/model/circle_recitation_model.dart';

// enum CircleRecitationsStatus { initial, loading, loadingMore, success, failure }

// class CircleRecitationsState {
//   final CircleRecitationsStatus status;
//   final List<CircleRecitationModel> items;
//   final CirclePaginationModel? pagination;
//   final String? errorMessage;

//   // Active filters
//   final String? fromDate;
//   final String? toDate;

//   const CircleRecitationsState({
//     this.status = CircleRecitationsStatus.initial,
//     this.items = const [],
//     this.pagination,
//     this.errorMessage,
//     this.fromDate,
//     this.toDate,
//   });

//   bool get hasActiveFilter => fromDate != null || toDate != null;

//   bool get canLoadMore =>
//       pagination != null &&
//       pagination!.hasNextPage &&
//       status != CircleRecitationsStatus.loadingMore;

//   CircleRecitationsState copyWith({
//     CircleRecitationsStatus? status,
//     List<CircleRecitationModel>? items,
//     CirclePaginationModel? pagination,
//     String? errorMessage,
//     String? fromDate,
//     String? toDate,
//     bool clearFromDate = false,
//     bool clearToDate = false,
//   }) {
//     return CircleRecitationsState(
//       status: status ?? this.status,
//       items: items ?? this.items,
//       pagination: pagination ?? this.pagination,
//       errorMessage: errorMessage,
//       fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
//       toDate: clearToDate ? null : (toDate ?? this.toDate),
//     );
//   }
// }

import 'package:masjid/feature/circles/data_source/model/circle_recitation_model.dart';

abstract class CircleRecitationsState {}

class CircleRecitationsInitialState extends CircleRecitationsState {}

class CircleRecitationsLoadingState extends CircleRecitationsState {}

class CircleRecitationsLoadMoreState extends CircleRecitationsState {
  final List<CircleRecitationModel> currentItems;
  CircleRecitationsLoadMoreState({required this.currentItems});
}

class CircleRecitationsSuccessState extends CircleRecitationsState {
  final List<CircleRecitationModel> items;
  final CirclePaginationModel pagination;
  CircleRecitationsSuccessState({
    required this.items,
    required this.pagination,
  });
}

class CircleRecitationsFailureState extends CircleRecitationsState {
  final String errMessage;
  CircleRecitationsFailureState({required this.errMessage});
}
