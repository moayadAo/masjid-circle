import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/storage/hive_boxes.dart';
import 'package:masjid/core/storage/hive_helper.dart';
import 'package:masjid/core/storage/hive_key.dart';
import 'package:masjid/feature/auth/data_source/remote/auth_service.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  final HiveHelper hiveHelper;
  late int cycleId;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  Future<String?> get role async =>
      await hiveHelper.getData(HiveBoxes.appBox, HiveKey.userRole) as String?;
  AuthCubit({required this.authService, required this.hiveHelper})
    : super(AuthInitialState());

  // ─── Login ───────────────────────────────────────────────
  Future<void> login({
    required String username,
    required String password,
    String? deviceName,
  }) async {
    emit(LoginLoadingState());

    final result = await authService.login(
      username: username,
      password: password,
      deviceName: deviceName,
    );

    result.fold(
      (errMessage) => emit(LoginFailureState(errMessage: errMessage)),
      (authData) async {
        // Store token securely
        await hiveHelper.saveData(
          HiveBoxes.appBox,
          HiveKey.token,
          authData.token,
        );
        cycleId = authData.activeCycle!.id; // Store cycleId in the cubit
        emit(LoginSuccessState(authData: authData));
      },
    );
  }

  // ─── Get Current User ────────────────────────────────────
  Future<void> getMe() async {
    emit(GetMeLoadingState());

    final result = await authService.getMe();

    result.fold(
      (errMessage) => emit(GetMeFailureState(errMessage: errMessage)),
      (meData) => emit(GetMeSuccessState(meData: meData)),
    );
  }

  // ─── Logout ──────────────────────────────────────────────
  Future<void> logout() async {
    emit(LogoutLoadingState());

    final result = await authService.logout();

    result.fold(
      (errMessage) => emit(LogoutFailureState(errMessage: errMessage)),
      (_) async {
        // Delete stored token
        await hiveHelper.deleteData(HiveBoxes.appBox, HiveKey.token);
        emit(LogoutSuccessState());
      },
    );
  }

  // ─── UI Helpers ──────────────────────────────────────────
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(TogglePasswordVisibilityState(isVisible: _isPasswordVisible));
  }
}
