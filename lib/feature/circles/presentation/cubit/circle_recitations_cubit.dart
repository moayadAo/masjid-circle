// // circle_recitations_cubit.dart

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:masjid/feature/circles/data_source/remote/circle_recitations_service.dart';

// import 'circle_recitations_state.dart';

// class CircleRecitationsCubit extends Cubit<CircleRecitationsState> {
//   final CircleRecitationsService service;
//   final int circleId;

//   static const int _perPage = 5;

//   CircleRecitationsCubit({required this.service, required this.circleId})
//     : super(const CircleRecitationsState());

//   // ── Load first page ───────────────────────────────────────────────────

//   Future<void> loadRecitations() async {
//     emit(state.copyWith(status: CircleRecitationsStatus.loading));

//     final response = await service.getCircleRecitations(
//       circleId: circleId,
//       page: 1,
//       perPage: _perPage,
//       fromDate: state.fromDate,
//       toDate: state.toDate,
//     );

//     response.fold(
//       (errMessage) => emit(
//         state.copyWith(
//           status: CircleRecitationsStatus.failure,
//           errorMessage: errMessage,
//         ),
//       ),
//       (result) => emit(
//         state.copyWith(
//           status: CircleRecitationsStatus.success,
//           items: result.items,
//           pagination: result.pagination,
//         ),
//       ),
//     );
//   }

//   // ── Load next page (pagination) ───────────────────────────────────────

//   Future<void> loadMore() async {
//     if (!state.canLoadMore) return;

//     emit(state.copyWith(status: CircleRecitationsStatus.loadingMore));

//     final nextPage = state.pagination!.currentPage + 1;

//     final response = await service.getCircleRecitations(
//       circleId: circleId,
//       page: nextPage,
//       perPage: _perPage,
//       fromDate: state.fromDate,
//       toDate: state.toDate,
//     );

//     response.fold(
//       (errMessage) => emit(
//         state.copyWith(
//           status: CircleRecitationsStatus.success,
//           errorMessage: errMessage,
//         ),
//       ),
//       (result) => emit(
//         state.copyWith(
//           status: CircleRecitationsStatus.success,
//           items: [...state.items, ...result.items],
//           pagination: result.pagination,
//         ),
//       ),
//     );
//   }

//   // ── Filters ──────────────────────────────────────────────────────────

//   Future<void> applyFilter({String? fromDate, String? toDate}) async {
//     emit(
//       state.copyWith(
//         fromDate: fromDate,
//         toDate: toDate,
//         clearFromDate: fromDate == null,
//         clearToDate: toDate == null,
//       ),
//     );
//     await loadRecitations();
//   }

//   Future<void> clearFilter() async {
//     emit(state.copyWith(clearFromDate: true, clearToDate: true));
//     await loadRecitations();
//   }
// }

// circle_recitations_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/circles/data_source/model/circle_recitation_model.dart';
import 'package:masjid/feature/circles/data_source/remote/circle_recitations_service.dart';

import 'circle_recitations_state.dart';

class CircleRecitationsCubit extends Cubit<CircleRecitationsState> {
  final CircleRecitationsService service;
  bool _isLoadingMore = false;

  CircleRecitationsCubit({required this.service})
    : super(CircleRecitationsInitialState());

  final List<CircleRecitationModel> _items = [];
  int _currentPage = 1;
  bool _hasNextPage = true;
  int? _circleId;

  String? _fromDate;
  String? _toDate;

  String? get fromDate => _fromDate;
  String? get toDate => _toDate;
  bool get hasActiveFilter => _fromDate != null || _toDate != null;
  int? get circleId => _circleId;

  // ── Load first page ───────────────────────────────────────

  Future<void> loadRecitations({required int circleId}) async {
    _circleId = circleId;
    _items.clear();
    _currentPage = 1;
    _hasNextPage = true;

    emit(CircleRecitationsLoadingState());

    final result = await service.getCircleRecitations(
      circleId: circleId,
      page: _currentPage,
      fromDate: _fromDate,
      toDate: _toDate,
    );

    result.fold((err) => emit(CircleRecitationsFailureState(errMessage: err)), (
      data,
    ) {
      _items.addAll(data.items);
      debugPrint('Loaded ${data.items.length} recitations');
      debugPrint('Loaded ${data.pagination.lastPage} lastPage');

      _hasNextPage = data.pagination.hasNextPage;
      emit(
        CircleRecitationsSuccessState(
          items: List.from(_items),
          pagination: data.pagination,
        ),
      );
    });
  }

  // ── Load next page ───────────────────────────────────────

  Future<void> loadMore() async {
    debugPrint('Attempting to load more recitations...');
    debugPrint(
      'Current page: $_currentPage, hasNextPage: $_hasNextPage, isLoadingMore: $_isLoadingMore',
    );
    if (_isLoadingMore || !_hasNextPage || _circleId == null) return;
    debugPrint('Loading more recitations...');
    _isLoadingMore = true;
    emit(CircleRecitationsLoadMoreState(currentItems: List.from(_items)));

    _currentPage++;
    final result = await service.getCircleRecitations(
      circleId: _circleId!,
      page: _currentPage,
      fromDate: _fromDate,
      toDate: _toDate,
    );

    result.fold(
      (err) {
        _currentPage--; // rollback
        emit(CircleRecitationsFailureState(errMessage: err));
      },
      (data) {
        _items.addAll(data.items);
        _hasNextPage = data.pagination.hasNextPage;
        emit(
          CircleRecitationsSuccessState(
            items: List.from(_items),
            pagination: data.pagination,
          ),
        );
      },
    );
    _isLoadingMore = false;
  }

  // ── Filters ──────────────────────────────────────────────

  Future<void> applyFilter({String? fromDate, String? toDate}) async {
    _fromDate = fromDate;
    _toDate = toDate;
    if (_circleId != null) {
      await loadRecitations(circleId: _circleId!);
    }
  }

  Future<void> clearFilter() async {
    _fromDate = null;
    _toDate = null;
    if (_circleId != null) {
      await loadRecitations(circleId: _circleId!);
    }
  }
}
