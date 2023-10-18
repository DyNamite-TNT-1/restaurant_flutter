abstract class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String messageSuccess;
  AuthenticationSuccess({required this.messageSuccess});
}

class Authenticating extends AuthenticationState {}

class AuthenticationFail extends AuthenticationState {
  final String messageError;
  AuthenticationFail({required this.messageError});
}

class AuthenticatingOTP extends AuthenticationState {}

class AuthenticateOTPFailed extends AuthenticationState {
  final String messageError;
  final String domain;
  final String branch;
  final String id;
  final String password;

  AuthenticateOTPFailed({
    required this.messageError,
    required this.domain,
    required this.branch,
    required this.id,
    required this.password,
  });
}
