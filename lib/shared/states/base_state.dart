/// Base class for all feature states managed by Riverpod Notifiers.
///
/// Extend this and add feature-specific fields:
/// ```dart
/// class AuthState extends BaseState {
///   const AuthState({super.isLoading, super.errorMessage, this.user});
///   final UserModel? user;
/// }
/// ```
abstract class BaseState {
  const BaseState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;

  bool get hasError => errorMessage != null;
  bool get isAuthenticated => false; // override in subclasses if needed

  @override
  String toString() =>
      'BaseState(isLoading: $isLoading, errorMessage: $errorMessage)';
}
