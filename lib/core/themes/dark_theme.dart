import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppDarkTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.primaryMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),

      scaffoldBackgroundColor: AppColors.primaryDark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.dark,
        primaryContainer: AppColors.primaryMedium,
        onPrimaryContainer: AppColors.light,
        secondary: AppColors.gray200,
        onSecondary: AppColors.dark,
        tertiary: AppColors.primary,
        onTertiary: AppColors.dark,
        error: AppColors.topicColor2,
        onError: AppColors.light,
        surface: AppColors.primaryMedium,
        onSurface: AppColors.light,
        onSurfaceVariant: AppColors.gray300,
      ),

      // Text themes with Lexend font
      textTheme: GoogleFonts.lexendTextTheme(
        TextTheme(
          displayLarge: GoogleFonts.lexend(
            fontSize: 57,
            fontWeight: FontWeight.w700,
            color: AppColors.light,
          ),
          displayMedium: GoogleFonts.lexend(
            fontSize: 45,
            fontWeight: FontWeight.w700,
            color: AppColors.light,
          ),
          displaySmall: GoogleFonts.lexend(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: AppColors.light,
          ),
          headlineLarge: GoogleFonts.lexend(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.light,
          ),
          headlineMedium: GoogleFonts.lexend(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.light,
          ),
          headlineSmall: GoogleFonts.lexend(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.light,
          ),
          titleLarge: GoogleFonts.lexend(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.light,
          ),
          titleMedium: GoogleFonts.lexend(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.light,
          ),
          titleSmall: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.light,
          ),
          bodyLarge: GoogleFonts.lexend(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.light,
          ),
          bodyMedium: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.gray200,
          ),
          bodySmall: GoogleFonts.lexend(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.gray300,
          ),
          labelLarge: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.light,
          ),
          labelMedium: GoogleFonts.lexend(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.gray200,
          ),
          labelSmall: GoogleFonts.lexend(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.gray300,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.primaryMedium,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryDarkAccent,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryDarkAccent,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.topicColor2, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.topicColor2, width: 2),
        ),
        hintStyle: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.gray300,
        ),
        labelStyle: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.gray200,
        ),
        helperStyle: GoogleFonts.lexend(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.gray300,
        ),
        errorStyle: GoogleFonts.lexend(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.topicColor2,
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.dark,
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: .5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.light,
          side: const BorderSide(color: AppColors.light, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.light,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.light,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.primaryMedium,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: AppColors.light),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.primaryDarkAccent,
        thickness: 1,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.primaryMedium,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.gray300,
        elevation: 8,
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.dark,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.primaryDarkAccent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.gray300;
        }),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.light;
          }
          return AppColors.gray300;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.primaryDarkAccent;
        }),
      ),
    );
  }
}
