// part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {}

class OnAuthenticationCheck extends AuthenticationEvent {}

class OnAuthenticationLogout extends AuthenticationEvent {
  final int timeout;
  final Function? callback;
  final String errorMessage;
  final bool ignoreApi;

  OnAuthenticationLogout({
    required this.timeout,
    this.callback,
    this.errorMessage = '',
    this.ignoreApi = false,
  });
}

class OnAuthenticate extends AuthenticationEvent {
  final Map<String, String> map;
  OnAuthenticate({required this.map});
}

class AuthenticationSwichLogin extends AuthenticationEvent {}
