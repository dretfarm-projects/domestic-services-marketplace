import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0F766E);
  static const primaryDark = Color(0xFF115E59);
  static const primarySoft = Color(0xFFCCFBF1);
  static const accent = Color(0xFFF59E0B);
  static const accentSoft = Color(0xFFFEF3C7);
  static const success = Color(0xFF15803D);
  static const successSoft = Color(0xFFDCFCE7);
  static const warning = Color(0xFFB45309);
  static const warningSoft = Color(0xFFFED7AA);
  static const error = Color(0xFFDC2626);
  static const errorSoft = Color(0xFFFEE2E2);
  static const info = Color(0xFF0369A1);
  static const bg = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textTertiary = Color(0xFF94A3B8);
  static const border = Color(0xFFE2E8F0);
  static const divider = Color(0xFFF1F5F9);

  // Dark mode
  static const bgDark = Color(0xFF0B1220);
  static const surfaceDark = Color(0xFF111827);
  static const textPrimaryDark = Color(0xFFF1F5F9);
  static const textSecondaryDark = Color(0xFF94A3B8);
  static const borderDark = Color(0xFF1F2937);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const full = 999.0;
}

class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
}

ThemeData lightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.accent,
    error: AppColors.error,
    surface: AppColors.surface,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: 'PlusJakartaSans',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      headlineMedium: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleLarge: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      bodyLarge: TextStyle(
          fontSize: 16, height: 1.4, color: AppColors.textPrimary),
      bodyMedium: TextStyle(
          fontSize: 14, height: 1.4, color: AppColors.textSecondary),
      bodySmall: TextStyle(
          fontSize: 12, height: 1.4, color: AppColors.textSecondary),
      labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'PlusJakartaSans'),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.border),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'PlusJakartaSans'),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: AppColors.textTertiary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.bg,
      selectedColor: AppColors.primarySoft,
      labelStyle: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans'),
    ),
  );
}

ThemeData darkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: const Color(0xFF2DD4BF),
    secondary: const Color(0xFFFBBF24),
    error: const Color(0xFFF87171),
    surface: AppColors.surfaceDark,
    brightness: Brightness.dark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.bgDark,
    fontFamily: 'PlusJakartaSans',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark),
      headlineMedium: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
      titleLarge: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
      bodyLarge: TextStyle(
          fontSize: 16, height: 1.4, color: AppColors.textPrimaryDark),
      bodyMedium: TextStyle(
          fontSize: 14, height: 1.4, color: AppColors.textSecondaryDark),
      bodySmall: TextStyle(
          fontSize: 12, height: 1.4, color: AppColors.textSecondaryDark),
      labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2DD4BF),
        foregroundColor: AppColors.bgDark,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'PlusJakartaSans'),
        elevation: 0,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.borderDark),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: Color(0xFF2DD4BF), width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: Color(0xFF2DD4BF),
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      centerTitle: false,
    ),
  );
}
