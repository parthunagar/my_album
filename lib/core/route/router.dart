import 'package:auto_route/annotations.dart';
import 'package:monirth_memories/core/auto_route_guards.dart';
import 'package:monirth_memories/ui/views/home/home_view.dart';
import 'package:monirth_memories/ui/views/splash_screen/splash_view.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
        path: '/splash',
        name: 'SplashRoute',
        page: SplashScreenView,
        initial: true,
        guards: [NotAuthGuard]
        ),
    AutoRoute(
      path: '/home',
      name: 'HomeRoute',
      page: HomeView,
    ),
  ],
)
class $AppRouter {}
