import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/configs/user_repository.dart';

import 'bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(InitialAuthenticationState()) {
    on<OnAuthenticate>(_onAuthenticate);
    on<OnAuthenticationCheck>(_onCheck);
    on<OnAuthenticationLogout>(_onLogout);
    on<AuthenticationSwichLogin>(_onSwitchLogin);
  }

  /// login
  Future<void> _onAuthenticate(OnAuthenticate event, Emitter emit) async {
    var login = event.map['login'];
    var password = event.map['password'];

    emit(Authenticating());

    if (login!.isEmpty || password!.isEmpty) {
      emit(AuthenticationFail(messageError: ''));
    } else {
      final result = await UserRepository.login(
        login: login,
        password: password,
      );

      if (result != null) {
        if (result.isSuccess) {
          emit(AuthenticationSuccess());
        } else {
          print(result.msg);
          emit(AuthenticationFail(messageError: result.msg));
        }
      } else {
        emit(AuthenticationFail(messageError: ''));
      }
    }
  }

  Future<void> _onCheck(OnAuthenticationCheck event, Emitter emit) async {
    // if (UserPreferences.isExistAuthenticateSession()) {
    //   String? userString = UserPreferences.getUserLoggedInfo();
    //   if (userString != null) {
    //     Map<String, dynamic> json = jsonDecode(userString);
    //     UserRepository.setUserModel(json);
    //   }

    //   emit(AuthenticationSuccess());
    // } else {
    //   emit(AuthenticationFail(messageError: ''));
    // }
  }

  Future<void> _onLogout(OnAuthenticationLogout event, Emitter emit) async {
    await UserRepository.logout(event.ignoreApi, event.timeout);

    // if (event.clearBiometric) {
    //   await UserPreferences.clearBiometricLogin();
    // }
    if (event.callback != null) {
      event.callback!();
    }

    emit(AuthenticationFail(messageError: event.errorMessage));
  }

  Future<void> _onSwitchLogin(
      AuthenticationSwichLogin event, Emitter emit) async {
    emit(AuthenticationFail(messageError: ''));
  }
}
