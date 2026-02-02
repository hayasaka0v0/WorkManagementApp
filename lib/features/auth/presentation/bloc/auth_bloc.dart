import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/auth/domain/entities/auth_user.dart';
import 'package:learning/features/auth/domain/usecases/get_current_user.dart';
import 'package:learning/features/auth/domain/usecases/login.dart';
import 'package:learning/features/auth/domain/usecases/logout.dart';
import 'package:learning/features/auth/domain/usecases/signup.dart';
import 'package:learning/features/company/domain/usecases/leave_company.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC for managing authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Signup signup;
  final Logout logout;
  final GetCurrentUser getCurrentUser;
  final LeaveCompany leaveCompany;

  AuthBloc({
    required this.login,
    required this.signup,
    required this.logout,
    required this.getCurrentUser,
    required this.leaveCompany,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckAuth);
    on<AuthLoginRequested>(_onLogin);
    on<AuthSignupRequested>(_onSignup);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthLeaveCompanyRequested>(_onLeaveCompany);
  }

  Future<void> _onCheckAuth(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await getCurrentUser(const NoParams());

    result.fold((failure) => emit(AuthUnauthenticated()), (user) {
      if (user == null) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    });
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await login(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignup(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signup(
      SignupParams(
        email: event.email,
        password: event.password,
        phoneNumber: event.phoneNumber,
        role: event.role,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await logout(const NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onLeaveCompany(
    AuthLeaveCompanyRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentUser = (state is AuthAuthenticated)
        ? (state as AuthAuthenticated).user
        : null;
    emit(AuthLoading());

    final result = await leaveCompany(LeaveCompanyParams(userId: event.userId));

    await result.fold(
      (failure) async {
        emit(AuthError(failure.message));
        if (currentUser != null) emit(AuthAuthenticated(currentUser));
      },
      (_) async {
        add(AuthCheckRequested());
      },
    );
  }
}
