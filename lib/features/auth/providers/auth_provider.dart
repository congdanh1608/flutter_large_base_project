import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dt_digital_studio/core/network/api_service_provider/auth_api_service_provider.dart';
import 'package:dt_digital_studio/models/user_model.dart';
import 'package:dt_digital_studio/shared/states/base_state.dart';

// ---- State ------------------------------------------------------------------

class AuthState extends BaseState {
  const AuthState({
    super.isLoading,
    super.errorMessage,
    this.user,
  });

  final UserModel? user;

  @override
  bool get isAuthenticated => user != null;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserModel? user,
    bool clearError = false,
    bool clearUser = false,
  }) =>
      AuthState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        user: clearUser ? null : user ?? this.user,
      );

  @override
  String toString() =>
      'AuthState(isLoading: $isLoading, user: ${user?.email}, error: $errorMessage)';
}

// ---- Providers --------------------------------------------------------------

final authServiceProviderInstance = Provider<AuthApiServiceProvider>(
  (_) => AuthApiServiceProvider(),
);

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

// ---- Notifier ---------------------------------------------------------------

/// Manages the authentication lifecycle.
///
/// State is [AuthState] — check [AuthState.isAuthenticated] and
/// [AuthState.user] instead of watching nullable `UserEntity?`.
class AuthNotifier extends Notifier<AuthState> {
  AuthApiServiceProvider get _service =>
      ref.read(authServiceProviderInstance);

  @override
  AuthState build() {
    // Kick off an async check without blocking build.
    _checkCurrentUser();
    return const AuthState(isLoading: true);
  }

  Future<void> _checkCurrentUser() async {
    final result = await _service.getCurrentUser();
    result.fold(
      onSuccess: (user) => state = AuthState(user: user),
      onFailure: (_) => state = const AuthState(),
    );
  }

  /// Returns `true` on success, `false` on failure.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _service.login(email: email, password: password);
    return result.fold(
      onSuccess: (user) {
        state = AuthState(user: user);
        return true;
      },
      onFailure: (failure) {
        state = AuthState(errorMessage: failure.toString());
        return false;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _service.logout();
    state = const AuthState();
  }
}
