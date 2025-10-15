import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.black),
      trackColor: WidgetStateProperty.all(Colors.white),
      overlayColor: WidgetStateProperty.all(Colors.white),
      trackOutlineColor: WidgetStateProperty.all(Colors.black),
    ),
    popupMenuTheme: PopupMenuThemeData(
      iconColor: Colors.black,
      textStyle: const TextStyle(color: Colors.white),
      labelTextStyle:
          WidgetStateProperty.all(const TextStyle(color: Colors.white)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStateProperty.all(Colors.black)),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.dancingScript(color: Colors.black),
      displayMedium: GoogleFonts.dancingScript(color: Colors.black),
      displaySmall: GoogleFonts.dancingScript(color: Colors.black),
      headlineLarge: GoogleFonts.dancingScript(color: Colors.black),
      headlineMedium: GoogleFonts.dancingScript(color: Colors.black),
      headlineSmall: GoogleFonts.dancingScript(color: Colors.black),
      titleLarge: GoogleFonts.dancingScript(color: Colors.black),
      titleMedium: GoogleFonts.dancingScript(color: Colors.black),
      titleSmall: GoogleFonts.dancingScript(color: Colors.black),
      bodyLarge: GoogleFonts.dancingScript(color: Colors.black),
      bodyMedium: GoogleFonts.dancingScript(color: Colors.black),
      bodySmall: GoogleFonts.dancingScript(color: Colors.black),
      labelLarge: GoogleFonts.dancingScript(color: Colors.black),
      labelMedium: GoogleFonts.dancingScript(color: Colors.black),
      labelSmall: GoogleFonts.dancingScript(color: Colors.black),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.all(Colors.black),
      overlayColor: WidgetStateProperty.all(Colors.black),
      trackOutlineColor: WidgetStateProperty.all(Colors.white),
    ),
    popupMenuTheme: PopupMenuThemeData(
      iconColor: Colors.white,
      textStyle: const TextStyle(color: Colors.white),
      labelTextStyle:
          WidgetStateProperty.all(const TextStyle(color: Colors.white)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStateProperty.all(Colors.white)),
    ),
    
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.dancingScript(color: Colors.white),
      displayMedium: GoogleFonts.dancingScript(color: Colors.white),
      displaySmall: GoogleFonts.dancingScript(color: Colors.white),
      headlineLarge: GoogleFonts.dancingScript(color: Colors.white),
      headlineMedium: GoogleFonts.dancingScript(color: Colors.white),
      headlineSmall: GoogleFonts.dancingScript(color: Colors.white),
      titleLarge: GoogleFonts.dancingScript(color: Colors.white),
      titleMedium: GoogleFonts.dancingScript(color: Colors.white),
      titleSmall: GoogleFonts.dancingScript(color: Colors.white),
      bodyLarge: GoogleFonts.dancingScript(color: Colors.white),
      bodyMedium: GoogleFonts.dancingScript(color: Colors.white),
      bodySmall: GoogleFonts.dancingScript(color: Colors.white),
      labelLarge: GoogleFonts.dancingScript(color: Colors.white),
      labelMedium: GoogleFonts.dancingScript(color: Colors.white),
      labelSmall: GoogleFonts.dancingScript(color: Colors.white),
    ),
  );
}
