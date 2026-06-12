import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/circles/data_source/remote/circles_service.dart';
import 'package:masjid/feature/circles/presentation/cubit/circles_state.dart';

class CirclesCubit extends Cubit<CirclesState> {
  final CirclesService circlesService;

  CirclesCubit({required this.circlesService}) : super(CirclesInitialState());

  Future<void> getMyCircles() async {
    emit(GetCirclesLoadingState());
    final result = await circlesService.getMyCircles();
    result.fold(
      (err) => emit(GetCirclesFailureState(errMessage: err)),
      (circles) => emit(GetCirclesSuccessState(circles: circles)),
    );
  }

  Future<void> getCircleStudents({required int circleId}) async {
    emit(GetStudentsLoadingState());
    final result = await circlesService.getCircleStudents(circleId: circleId);
    result.fold(
      (err) => emit(GetStudentsFailureState(errMessage: err)),
      (students) => emit(GetStudentsSuccessState(students: students)),
    );
  }
}
