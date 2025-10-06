import 'package:monirth_memories/core/auto_route_guards.dart';
import 'package:monirth_memories/utils/style.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'core/route/router.gr.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSize = 100; // default 1000
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20; // 100 MB
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _appRouter = AppRouter(
    notAuthGuard: NotAuthGuard(),
    navigatorKey: StackedService.navigatorKey, //MyApp.navKey,
  );

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (context) {
        return MaterialApp.router(
          title: "Marrige Photo",
          debugShowCheckedModeBanner: false,
          theme: AppStyle.angloLightTheme,
          darkTheme: AppStyle.angloLightTheme,
          themeMode: ThemeMode.light,
          routeInformationParser:
              _appRouter.defaultRouteParser(includePrefixMatches: true),
          // routerDelegate: AppRouter().delegate(),
          // routerDelegate: _appRouter.delegate(navigatorObservers: () => [routeObserver, MyApp.observer]),
          routerDelegate: _appRouter.delegate(),
          // routeInformationProvider: _appRouter.delegate(
          //   navigatorObservers: () => [routeObserver, MyApp.observer],
          // ),
        );
      },
    );
  }
}
