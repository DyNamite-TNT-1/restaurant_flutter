import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/blocs/app_bloc.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/blocs/ui/ui_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/routes/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    AppBloc.applicationBloc.add(OnSetupApplication());
  }

  @override
  void dispose() {
    super.dispose();
    AppBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: BlocBuilder<UiBloc, UiState>(
        builder: (context, state) {
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return MaterialApp.router(
                theme: CollectionTheme.getCollectionTheme(),
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
