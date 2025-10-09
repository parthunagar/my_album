import 'package:monirth_memories/core/app.locator.dart';
import 'package:monirth_memories/core/auto_route_guards.dart';
import 'package:flutter/services.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';
import 'package:monirth_memories/utils/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'core/route/router.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  PaintingBinding.instance.imageCache.maximumSize = 100; // default 1000
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20; // 100 MB
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
}

ThemeMode themeMode = ThemeMode.light;

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  final appRouter = AppRouter(
    notAuthGuard: NotAuthGuard(),
    navigatorKey: StackedService.navigatorKey,
  );

  @override
  // ignore: no_logic_in_create_state
  State<MyApp> createState() => _MyAppState(appRouter);
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppRouter appRouter;
  _MyAppState(this.appRouter);
  final themeViewModel = locator<PreferenceService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PreferenceService>.reactive(
      viewModelBuilder: () => themeViewModel,
      disposeViewModel: false,
      builder: (context, model, child) {
        return ResponsiveApp(
          builder: (context) {
            return MaterialApp.router(
              title: "Marrige Photo",
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeViewModel.themeMode,
              routeInformationParser:
                  appRouter.defaultRouteParser(includePrefixMatches: true),
              routerDelegate: appRouter.delegate(),
            );
          },
        );
      },
    );
  }
}
