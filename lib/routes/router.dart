import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/screens/dashboard/dashboard.dart';
import 'package:restaurant_flutter/screens/dish/detail_dish.dart';
import 'package:restaurant_flutter/nested_navigation.dart';
import 'package:restaurant_flutter/screens/dish/dish.dart';
import 'package:restaurant_flutter/screens/drink/detail_drink.dart';
import 'package:restaurant_flutter/screens/drink/drink.dart';
import 'package:restaurant_flutter/screens/profile/profile.dart';
import 'package:restaurant_flutter/screens/vacant/vacant.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboardKey =
    GlobalKey<NavigatorState>(debugLabel: "shellDashboard");
final _shellNavigatorDishKey =
    GlobalKey<NavigatorState>(debugLabel: "shellDish");
final _shellNavigatorDrinkKey =
    GlobalKey<NavigatorState>(debugLabel: "shellDrink");
final _shellNavigatorVacantKey =
    GlobalKey<NavigatorState>(debugLabel: "shellService");

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: "/dashboard",
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDashboardKey,
            routes: [
              GoRoute(
                path: "/dashboard",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: Dashboard(),
                  );
                },
                routes: [],
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
            navigatorKey: _shellNavigatorVacantKey,
            routes: [
              GoRoute(
                name: RouteConstants.vacant,
                path: "/vacant",
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: VacantScreen(),
                  );
                },
                routes: [],
              )
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      bool isAuthenticated = true;
      if (!isAuthenticated) {
        return state.namedLocation(RouteConstants.login);
      }
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