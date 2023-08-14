import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/blocs/app_bloc.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/routes/router.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return MaterialApp.router(
            theme: CollectionTheme.getCollectionTheme(),
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
