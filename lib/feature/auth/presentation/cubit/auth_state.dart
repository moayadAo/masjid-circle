import 'package:masjid/feature/auth/data_source/model/auth_response_model.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

// ─── Login ───────────────────────────────────────────────
class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final AuthResponseModel authData;
  LoginSuccessState({required this.authData});
}

class LoginFailureState extends AuthState {
  final String errMessage;
  LoginFailureState({required this.errMessage});
}

// ─── Me ──────────────────────────────────────────────────
class GetMeLoadingState extends AuthState {}

class GetMeSuccessState extends AuthState {
  final MeResponseModel meData;
  GetMeSuccessState({required this.meData});
}

class GetMeFailureState extends AuthState {
  final String errMessage;
  GetMeFailureState({required this.errMessage});
}

// ─── Logout ──────────────────────────────────────────────
class LogoutLoadingState extends AuthState {}

class LogoutSuccessState extends AuthState {}

class LogoutFailureState extends AuthState {
  final String errMessage;
  LogoutFailureState({required this.errMessage});
}

// ─── Password Visibility ─────────────────────────────────
class TogglePasswordVisibilityState extends AuthState {
  final bool isVisible;
  TogglePasswordVisibilityState({required this.isVisible});
}
