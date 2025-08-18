import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

ThemeData buildAppTheme() {
  final baseTextTheme = GoogleFonts.robotoTextTheme();

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    primaryColor: AppColors.accentBlue,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentBlue,
      surface: AppColors.card,
      onSurface: AppColors.primaryText,
      secondary: AppColors.accentBlue,
    ),
    textTheme: baseTextTheme.apply(
      bodyColor: AppColors.primaryText,
      displayColor: AppColors.primaryText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      margin: const EdgeInsets.all(0),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.card,
      selectedItemColor: AppColors.accentBlue,
      unselectedItemColor: AppColors.secondaryText,
      type: BottomNavigationBarType.fixed,
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(AppColors.accentBlue),
      trackColor: WidgetStatePropertyAll(Color(0xFF1B2A41)),
    ),
  );
}


