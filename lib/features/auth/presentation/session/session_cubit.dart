import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/auth_repository.dart';
import '../../domain/user.dart';

enum SessionStatus { unknown, unauthenticated, authenticated }

class SessionState extends Equatable {
  const SessionState._({
    required this.status,
    this.user,
    this.onboardingSeen = false,
    this.message,
  });

  const SessionState.unknown() : this._(status: SessionStatus.unknown);

  const SessionState.unauthenticated({bool onboardingSeen = true, String? message})
      : this._(
          status: SessionStatus.unauthenticated,
          onboardingSeen: onboardingSeen,
          message: message,
        );

  const SessionState.authenticated(User user)
      : this._(status: SessionStatus.authenticated, user: user, onboardingSeen: true);

  final SessionStatus status;
  final User? user;
  final bool onboardingSeen;

  /// One-off notice for the login screen (session expired, no connection).
  final String? message;

  @override
  List<Object?> get props => [status, user, onboardingSeen, message];
}

/// App-wide authentication state; the router redirects on its changes.
class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._repository) : super(const SessionState.unknown());

  final AuthRepository _repository;

  /// Called once on launch (US-02, AC 5: a valid token opens Home directly).
  Future<void> restore() async {
    final onboardingSeen = await _repository.isOnboardingSeen();
    if (!await _repository.hasToken()) {
      emit(SessionState.unauthenticated(onboardingSeen: onboardingSeen));
      return;
    }
    try {
      emit(SessionState.authenticated(await _repository.currentUser()));
    } on ApiException catch (e) {
      if (!e.isNetwork) await _repository.logout();
      emit(SessionState.unauthenticated(
        onboardingSeen: true,
        message: e.isNetwork ? "Немає з'єднання з сервером" : null,
      ));
    }
  }

  Future<void> completeOnboarding() async {
    await _repository.markOnboardingSeen();
    emit(const SessionState.unauthenticated(onboardingSeen: true));
  }

  /// After a successful login or registration.
  Future<void> signedIn() async {
    emit(SessionState.authenticated(await _repository.currentUser()));
  }

  /// Re-checks the token (e.g. when the app returns to the foreground).
  Future<void> refresh() async {
    if (state.status != SessionStatus.authenticated) return;
    try {
      emit(SessionState.authenticated(await _repository.currentUser()));
    } on ApiException {
      // 401 is handled by sessionExpired() via the API client; network errors
      // keep the user signed in.
    }
  }

  /// US-06: log out on this device.
  Future<void> logout() async {
    await _repository.logout();
    emit(const SessionState.unauthenticated());
  }

  /// The API client saw a 401 on an authorised request (token older than
  /// 60 minutes or the account was deactivated).
  void sessionExpired() {
    if (state.status != SessionStatus.authenticated) return;
    emit(const SessionState.unauthenticated(
      message: 'Сесія завершилась, увійдіть знову',
    ));
  }

  void clearMessage() {
    if (state.message == null) return;
    emit(SessionState.unauthenticated(onboardingSeen: state.onboardingSeen));
  }
}
