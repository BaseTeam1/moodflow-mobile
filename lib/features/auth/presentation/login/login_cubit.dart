import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/error_messages.dart';
import '../../domain/auth_repository.dart';
import '../session/session_cubit.dart';

class LoginState extends Equatable {
  const LoginState({this.submitting = false, this.error});

  final bool submitting;

  /// Shown above the button: "Невірний email або пароль", etc.
  final String? error;

  @override
  List<Object?> get props => [submitting, error];
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this._repository, required this._session})
      : super(const LoginState());

  final AuthRepository _repository;
  final SessionCubit _session;

  Future<void> submit({required String email, required String password}) async {
    if (state.submitting) return;
    emit(const LoginState(submitting: true));
    try {
      await _repository.login(email: email, password: password);
      await _session.signedIn();
      if (!isClosed) emit(const LoginState());
    } catch (e) {
      await _repository.logout();
      if (!isClosed) emit(LoginState(error: errorMessage(e)));
    }
  }

  void clearError() {
    if (state.error != null) emit(const LoginState());
  }
}
