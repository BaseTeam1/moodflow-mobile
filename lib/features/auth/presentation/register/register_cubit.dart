import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/error_messages.dart';
import '../../domain/auth_repository.dart';
import '../session/session_cubit.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.submitting = false,
    this.error,
    this.fieldErrors = const {},
  });

  final bool submitting;

  /// General error shown above the button.
  final String? error;

  /// Server errors bound to a field: `email`, `password`, `parent_email`, ...
  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [submitting, error, fieldErrors];
}

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this._repository, required this._session})
      : super(const RegisterState());

  final AuthRepository _repository;
  final SessionCubit _session;

  /// US-01: create the account, then sign in automatically (AC 1).
  Future<void> submit(RegistrationData data) async {
    if (state.submitting) return;
    emit(const RegisterState(submitting: true));
    try {
      await _repository.register(data);
    } on ApiException catch (e) {
      if (!isClosed) emit(_fromApiError(e));
      return;
    } catch (e) {
      if (!isClosed) emit(RegisterState(error: errorMessage(e)));
      return;
    }

    try {
      await _repository.login(email: data.email, password: data.password);
      await _session.signedIn();
      if (!isClosed) emit(const RegisterState());
    } catch (e) {
      await _repository.logout();
      if (!isClosed) {
        emit(RegisterState(
          error: 'Акаунт створено, але не вдалося увійти. ${errorMessage(e)}',
        ));
      }
    }
  }

  void clearFieldError(String field) {
    if (!state.fieldErrors.containsKey(field) && state.error == null) return;
    emit(RegisterState(
      fieldErrors: Map.of(state.fieldErrors)..remove(field),
    ));
  }

  RegisterState _fromApiError(ApiException e) {
    if (e.code == 'email_already_registered') {
      return const RegisterState(
        fieldErrors: {'email': 'Цей email вже зареєстрований'},
      );
    }
    if (e.code == 'validation_error') {
      final fields = {
        for (final f in e.invalidFields) f: 'Перевірте це поле',
      };
      return RegisterState(error: errorMessage(e), fieldErrors: fields);
    }
    return RegisterState(error: errorMessage(e));
  }
}
