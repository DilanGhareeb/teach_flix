import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF3366FF);
  static const Color secondaryColor = Color(0xFFFF3B30);

  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color darkBackgroundColor = Color(0xFF121212);

  static const Color lightCardColor = Color(0xFFF5F7FA);
  static const Color darkCardColor = Color(0xFF1E1E1E);

  static const Color lightPrimaryText = Color(0xFF1E1E1E);
  static const Color lightSecondaryText = Color(0xFF4A4A4A);
  static const Color lightHintText = Color(0xFF9B9B9B);

  static const Color darkPrimaryText = Color(0xFFE5E5E5);
  static const Color darkSecondaryText = Color(0xFFCCCCCC);

  static const Color lightInputFill = Color(0xFFF0F0F0);

  // Pick a family based on locale
  static String _familyFor(String locale) =>
      (locale == 'ckb' || locale == 'ar') ? 'NRT' : 'RobotoCustom';

  static ThemeData lightTheme(String locale) {
    final family = _familyFor(locale);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightCardColor,
        onSurface: lightPrimaryText,
      ),
      scaffoldBackgroundColor: lightBackgroundColor,
      fontFamily: family,
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: lightPrimaryText),
        titleTextStyle: TextStyle(
          color: lightPrimaryText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: family,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontFamily: family,
          fontWeight: FontWeight.w700,
          color: lightPrimaryText,
        ),
        bodyLarge: TextStyle(
          fontFamily: family,
          fontWeight: FontWeight.w500,
          color: lightSecondaryText,
        ),
        bodySmall: TextStyle(
          fontFamily: family,
          fontWeight: FontWeight.w400,
          color: lightHintText,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightCardColor,
        shadowColor: Colors.black12,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightInputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: lightHintText),
      ),
      iconTheme: const IconThemeData(color: lightPrimaryText),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(
            showUnselectedLabels: true,
            elevation: 8,
          ).copyWith(
            backgroundColor: lightCardColor,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
          ),
    );
  }

  static ThemeData darkTheme(String locale) {
    final family = _familyFor(locale);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkCardColor,
        onSurface: darkPrimaryText,
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      fontFamily: family,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkPrimaryText),
        titleTextStyle: TextStyle(
          fontFamily: family,
          color: darkPrimaryText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontFamily: family,
          fontWeight: FontWeight.w700,
          color: darkPrimaryText,
        ),
        bodyLarge: TextStyle(
          fontFamily: family,
          fontWeight: FontWeight.w500,
          color: darkSecondaryText,
        ),
        bodySmall: TextStyle(
          fontFamily: family,
          fontWeight: FontWeight.w400,
          color: darkSecondaryText,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCardColor,
        shadowColor: Colors.black54,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: darkSecondaryText),
      ),
      iconTheme: const IconThemeData(color: darkPrimaryText),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(
            showUnselectedLabels: true,
            elevation: 8,
          ).copyWith(
            backgroundColor: darkCardColor,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
          ),
    );
  }
}
