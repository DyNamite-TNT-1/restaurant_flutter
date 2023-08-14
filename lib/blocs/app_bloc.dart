import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class AppBloc {
  static final applicationBloc = ApplicationBloc();
  // static final languageBloc = LanguageBloc();
  // static final themeBloc = ThemeBloc();
  static final authenticationBloc = AuthenticationBloc();

  static final List<BlocProvider> providers = [
    BlocProvider<ApplicationBloc>(
      create: (context) => applicationBloc,
    ),
    // BlocProvider<LanguageBloc>(
    //   create: (context) => languageBloc,
    // ),
    // BlocProvider<ThemeBloc>(
    //   create: (context) => themeBloc,
    // ),
    BlocProvider<AuthenticationBloc>(
      create: (context) => authenticationBloc,
    ),
  ];

  static void dispose() {
    applicationBloc.close();
    // languageBloc.close();
    // themeBloc.close();
    authenticationBloc.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
