import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class MyCubitObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('Cubit created: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('Cubit state changed: ${bloc.runtimeType}');
    log('  Current state: ${change.currentState}');
    log('  Next state: ${change.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('Cubit error: ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('Cubit closed: ${bloc.runtimeType}');
  }
}
