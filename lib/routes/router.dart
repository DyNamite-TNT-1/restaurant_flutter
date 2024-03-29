import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/screens/authentication/otp_screen.dart';
import 'package:restaurant_flutter/screens/authentication/signup_screen.dart';
import 'package:restaurant_flutter/screens/dashboard/dashboard.dart';
import 'package:restaurant_flutter/screens/dish/detail_dish.dart';
import 'package:restaurant_flutter/nested_navigation.dart';
import 'package:restaurant_flutter/screens/dish/dish_screen.dart';
import 'package:restaurant_flutter/screens/drink/detail_drink.dart';
import 'package:restaurant_flutter/screens/drink/drink_screen.dart';
import 'package:restaurant_flutter/screens/loading/splash_screen.dart';
import 'package:restaurant_flutter/screens/profile/profile.dart';
import 'package:restaurant_flutter/screens/reservation/reservation_detail_screen.dart';
import 'package:restaurant_flutter/screens/reservation/reservation_screen.dart';
import 'package:restaurant_flutter/screens/service/service_screen.dart';
import 'package:restaurant_flutter/screens/setting/setting_change_language.dart';
import 'package:restaurant_flutter/screens/setting/setting_screen.dart';
import 'package:restaurant_flutter/utils/parse_type_value.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboardKey =
    GlobalKey<NavigatorState>(debugLabel: "shellDashboard");
final _shellNavigatorDishKey =
    GlobalKey<NavigatorState>(debugLabel: "shellDish");
final _shellNavigatorDrinkKey =
    GlobalKey<NavigatorState>(debugLabel: "shellDrink");
final _shellNavigatorServiceKey =
    GlobalKey<NavigatorState>(debugLabel: "shellService");
final _shellNavigatorReservationKey =
    GlobalKey<NavigatorState>(debugLabel: "shellReservation");
final _shellNavigatorSettingKey =
    GlobalKey<NavigatorState>(debugLabel: "shellSetting");

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: "/",
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: RouteConstants.splash,
        path: "/",
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: SplashScreen(),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDashboardKey,
            routes: [
              GoRoute(
                name: RouteConstants.dashboard,
                path: "/dashboard",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: Dashboard(),
                  );
                },
                routes: const [],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDishKey,
            routes: [
              GoRoute(
                name: RouteConstants.dishes,
                path: "/dish",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: DishScreen(),
                  );
                },
                routes: [
                  GoRoute(
                    name: RouteConstants.dishDetail,
                    path: "detail/:id",
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        child: DishDetailScreen(
                          id: state.pathParameters["id"] ?? "null",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDrinkKey,
            routes: [
              GoRoute(
                name: RouteConstants.drinks,
                path: "/drink",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: DrinkScreen(),
                  );
                },
                routes: [
                  GoRoute(
                    name: RouteConstants.drinkDetail,
                    path: "detail/:id",
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        child: DrinkDetailScreen(
                          id: state.pathParameters["id"] ?? "null",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorServiceKey,
            routes: [
              GoRoute(
                name: RouteConstants.service,
                path: "/service",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: ServiceScreen(),
                  );
                },
                routes: const [],
              )
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorReservationKey,
            routes: [
              GoRoute(
                name: RouteConstants.reservation,
                path: "/reservation",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: ReservationScreen(),
                  );
                },
                routes: [
                  GoRoute(
                    name: RouteConstants.reservationDetail,
                    path: "detail/:id",
                    pageBuilder: (context, state) {
                      int id =
                          ParseTypeData.ensureInt(state.pathParameters["id"]);
                      Function? backToParent;
                      final params = state.extra as Map<String, dynamic>;
                      backToParent = params["backToParent"];

                      return MaterialPage(
                        child: ReservationDetailScreen(
                          id: id,
                          backToParent: backToParent,
                        ),
                      );
                    },
                    redirect: (context, state) {
                      if (state.extra == null) {
                        return "/reservation";
                      }
                      return null;
                    },
                  ),
                ],
              )
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingKey,
            routes: [
              GoRoute(
                name: RouteConstants.setting,
                path: "/setting",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: SettingScreen(),
                  );
                },
                routes: [
                  GoRoute(
                    name: RouteConstants.settingLanguage,
                    path: "setting-language",
                    pageBuilder: (context, state) {
                      final params = state.extra as Map<String, dynamic>;
                      final String initLangCode =
                          ParseTypeData.ensureString(params["initLangCode"]);
                      return MaterialPage(
                        child:
                            SettingChangeLanguage(initLangCode: initLangCode),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: RouteConstants.signUp,
        path: "/signup",
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: SignUpScreen(),
          );
        },
        routes: [
          GoRoute(
            name: RouteConstants.verifyOTP,
            path: "verify",
            pageBuilder: (context, state) {
              final params = state.extra as Map<String, dynamic>;
              final String email = ParseTypeData.ensureString(params["email"]);
              return MaterialPage(
                child: OtpScreen(email: email),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: RouteConstants.profile,
        path: "/profile",
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: Profile(),
          );
        },
      ),
    ],
    redirect: (context, state) {
      // var authState = context.watch<AuthenticationBloc>().state;
      // bool isAuthenticated = authState is AuthenticationSuccess;
      // if (state.matchedLocation == "/profile") {
      //   if (!isAuthenticated) {
      //     return state.namedLocation(RouteConstants.dashboard);
      //   } else {
      //     state.namedLocation(RouteConstants.profile);
      //   }
      // }
      return null;
    },
  );

  ///Singleton factory
  static final AppRouter _instance = AppRouter._internal();

  factory AppRouter() {
    return _instance;
  }

  AppRouter._internal();
}
