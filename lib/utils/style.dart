import 'package:monirth_memories/utils/colors_utils.dart';
import 'package:flutter/material.dart';

T darkModeBase<T>(bool isDark, {T? light, T? dark}) {
  T child;
  if (!isDark || dark == null) {
    child = light as T;
  } else {
    child = dark;
  }
  return child;
}

class AppStyle extends StatelessWidget {
  final Widget child;

  const AppStyle({Key? key, required this.child}) : super(key: key);

  static const String bold = 'Roboto_bold';
  
  static TextTheme angloBlackRobotoCondensed = const TextTheme(
    displayLarge: TextStyle(
        debugLabel: 'blackRobotoCondensed headline1',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black54,
        decoration: TextDecoration.none),
    displayMedium: TextStyle(
        debugLabel: 'blackRobotoCondensed headline2',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black54,
        decoration: TextDecoration.none),
    displaySmall: TextStyle(
        debugLabel: 'blackRobotoCondensed headline3',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black54,
        decoration: TextDecoration.none),
    headlineMedium: TextStyle(
        debugLabel: 'blackRobotoCondensed headline4',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black54,
        decoration: TextDecoration.none),
    headlineSmall: TextStyle(
        debugLabel: 'blackRobotoCondensed headline5',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black87,
        decoration: TextDecoration.none),
    titleLarge: TextStyle(
        debugLabel: 'blackRobotoCondensed headline6',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black87,
        decoration: TextDecoration.none),
    bodyLarge: TextStyle(
        debugLabel: 'blackRobotoCondensed bodyText1',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black87,
        decoration: TextDecoration.none),
    bodyMedium: TextStyle(
        debugLabel: 'blackRobotoCondensed bodyText2',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black87,
        decoration: TextDecoration.none),
    titleMedium: TextStyle(
        debugLabel: 'blackRobotoCondensed subtitle1',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black87,
        decoration: TextDecoration.none),
    titleSmall: TextStyle(
        debugLabel: 'blackRobotoCondensed subtitle2',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black,
        decoration: TextDecoration.none),
    bodySmall: TextStyle(
        debugLabel: 'blackRobotoCondensed caption',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black54,
        decoration: TextDecoration.none),
    labelLarge: TextStyle(
        debugLabel: 'blackRobotoCondensed button',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black87,
        decoration: TextDecoration.none),
    labelSmall: TextStyle(
        debugLabel: 'blackRobotoCondensed overline',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.black,
        decoration: TextDecoration.none),
  );

  static TextTheme angloWhiteRobotoCondensed = const TextTheme(
    displayLarge: TextStyle(
        debugLabel: 'whiteRobotoCondensed headline1',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white70,
        decoration: TextDecoration.none),
    displayMedium: TextStyle(
        debugLabel: 'whiteRobotoCondensed headline2',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white70,
        decoration: TextDecoration.none),
    displaySmall: TextStyle(
        debugLabel: 'whiteRobotoCondensed headline3',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white70,
        decoration: TextDecoration.none),
    headlineMedium: TextStyle(
        debugLabel: 'whiteRobotoCondensed headline4',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white70,
        decoration: TextDecoration.none),
    headlineSmall: TextStyle(
        debugLabel: 'whiteRobotoCondensed headline5',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white,
        decoration: TextDecoration.none),
    titleLarge: TextStyle(
        debugLabel: 'whiteRobotoCondensed headline6',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white,
        decoration: TextDecoration.none),
    titleMedium: TextStyle(
        debugLabel: 'whiteRobotoCondensed subtitle1',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white,
        decoration: TextDecoration.none),
    bodyLarge: TextStyle(
        debugLabel: 'whiteRobotoCondensed bodyText1',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white,
        decoration: TextDecoration.none),
    bodyMedium: TextStyle(
        debugLabel: 'whiteRobotoCondensed bodyText2',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white,
        decoration: TextDecoration.none),
    bodySmall: TextStyle(
        debugLabel: 'whiteRobotoCondensed caption',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white70,
        decoration: TextDecoration.none),
    labelLarge: TextStyle(
        debugLabel: 'whiteRobotoCondensed button',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white,
        decoration: TextDecoration.none),
    titleSmall: TextStyle(
        debugLabel: 'whiteRobotoCondensed subtitle2',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white,
        decoration: TextDecoration.none),
    labelSmall: TextStyle(
        debugLabel: 'whiteRobotoCondensed overline',
        fontFamily: 'RobotoCondensed',
        inherit: true,
        color: Colors.white,
        decoration: TextDecoration.none),
  );

  static TextTheme angloLightText = ThemeData.light().textTheme.copyWith(
        displayLarge: const TextStyle(
            fontSize: 96.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        displayMedium: const TextStyle(
            fontSize: 60.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        displaySmall: const TextStyle(
            fontSize: 48.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        headlineMedium: const TextStyle(
            fontSize: 34.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        headlineSmall: const TextStyle(
            fontSize: 24.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        titleLarge: const TextStyle(
            fontSize: 20.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        titleMedium: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700),
        titleSmall: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700),
        bodyLarge: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w400),
        bodyMedium: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w400),
        labelLarge: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w400),
        bodySmall: const TextStyle(
            fontSize: 12.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w400),
        labelSmall: const TextStyle(
            fontSize: 10.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w400),
      );

  static TextTheme angloDarkText = ThemeData.dark().textTheme.copyWith(
        displayLarge: const TextStyle(
            fontSize: 96.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        displayMedium: const TextStyle(
            fontSize: 60.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        displaySmall: const TextStyle(
            fontSize: 48.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        headlineMedium: const TextStyle(
            fontSize: 34.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        headlineSmall: const TextStyle(
            fontSize: 24.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        titleLarge: const TextStyle(
            fontSize: 20.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w800),
        titleMedium: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700),
        titleSmall: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700),
        bodyLarge: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w400),
        bodyMedium: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w400),
        labelLarge: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w400),
        bodySmall: const TextStyle(
            fontSize: 12.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w400),
        labelSmall: const TextStyle(
            fontSize: 10.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w400),
      );

  ///
  ///PRIMARY [DARK] THEME
  ///
  /*
  static ThemeData primaryDarkTheme = darkTheme.copyWith(
    appBarTheme: darkTheme.appBarTheme.copyWith(
      brightness: Brightness.dark,
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: false,
      textTheme: darkText,
    ),
  ); 
  */

  ///
  ///PRIMARY [LIGHT] THEME
  ///
  /*
  static ThemeData primaryLightTheme = lightTheme.copyWith(
    appBarTheme: lightTheme.appBarTheme.copyWith(
      // systemOverlayStyle: SystemUiOverlayStyle(),
      brightness: Brightness.dark,
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: false,
      textTheme: darkText,
    ),
  );
   */

  /*
	 *  LIGHT THEME
	 */
  static ThemeData angloLightTheme = ThemeData(
    // brightness: Brightness.light,
    fontFamily: 'RobotoCondensed',
    textTheme: angloBlackRobotoCondensed, 
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      primaryContainer: AppColors.black,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.black,
      error: Colors.red,
      surface: Colors.white,
      // background: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onSurface: Colors.black,
      // onBackground: Colors.black,
    ),
    // backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: ThemeData.light().iconTheme,
    // toggleableActiveColor: AngloColors.black,
    primaryTextTheme: angloLightText,
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
          backgroundColor: AppColors.primary,
          elevation: 1,
          centerTitle: false,
          // textTheme: lightText,
        ),
    bottomNavigationBarTheme:
        ThemeData.light().bottomNavigationBarTheme.copyWith(
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primary,
            ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      fillColor: Colors.white,
      focusColor: AppColors.primary,
      labelStyle: const TextStyle(color: Colors.black),
      hintStyle: TextStyle(color: AppColors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      errorStyle: const TextStyle(color: Colors.red),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
      ),
    ),
    cardTheme: ThemeData.light().cardTheme,
    cardColor: ThemeData.light().cardColor,
    buttonTheme: ThemeData.light().buttonTheme.copyWith(
          buttonColor: AppColors.primary,
          colorScheme: const ColorScheme(
            primary: AppColors.primary,
            primaryContainer: AppColors.primary,
            secondary: AppColors.secondary,
            secondaryContainer: AppColors.secondary,
            surface: AppColors.primary,
            // background: AppColors.primary,
            error: Colors.red,
            onPrimary: AppColors.primary,
            onSecondary: AppColors.primary,
            onSurface: AppColors.primary,
            // onBackground: AppColors.primary,
            onError: Colors.red,
            brightness: Brightness.light,
          ),
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: AppColors.primary,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: AppColors.primary,
      ),
    ),
  );

  /*
	 *  Dark THEME
	 */
  static ThemeData angloDarkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'RobotoCondensed',
    textTheme: angloWhiteRobotoCondensed,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: ThemeData.dark().iconTheme,
    primaryTextTheme: angloDarkText,
    appBarTheme: ThemeData.dark().appBarTheme.copyWith(
          color: Colors.black,
          elevation: 1,
          centerTitle: false,
          // textTheme: darkText,
        ),
    bottomNavigationBarTheme:
        ThemeData.dark().bottomNavigationBarTheme.copyWith(
              backgroundColor: Colors.black,
              selectedItemColor: AppColors.primary,
            ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black),
      hintStyle: TextStyle(color: AppColors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 2,
        ),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      errorStyle: const TextStyle(color: Colors.red),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
      ),
    ),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.secondary),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppStyle.angloLightTheme,
      child: child,
    );
  }
}
