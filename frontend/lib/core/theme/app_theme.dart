import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4A42D4);
  static const Color primaryLight = Color(0xFF9C94FF);
  static const Color accent = Color(0xFF00D4AA);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusInProgress = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF10B981);
  static const Color statusCancelled = Color(0xFF6B7280);

  static const Color priorityLow = Color(0xFF10B981);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityUrgent = Color(0xFF7C3AED);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Sora',
        colorScheme: const ColorScheme.light(
          primary: primary,
          onPrimary: Colors.white,
          primaryContainer: Color(0xFFEEEDFF),
          secondary: accent,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF1A1A2E),
          surfaceContainerHighest: Color(0xFFF8F8FF),
          outline: Color(0xFFE2E8F0),
          error: error,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F8FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1A1A2E),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Sora',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: primary, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primary,
            textStyle: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8F8FF),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: error, width: 2),
          ),
          labelStyle: const TextStyle(
            fontFamily: 'Sora',
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
          hintStyle: const TextStyle(
            fontFamily: 'Sora',
            fontSize: 14,
            color: Color(0xFFCBD5E1),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFF1F0FF),
          selectedColor: primary,
          labelStyle: const TextStyle(fontFamily: 'Sora', fontSize: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: CircleBorder(),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE2E8F0),
          thickness: 1,
          space: 0,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Sora', fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
          displayMedium: TextStyle(fontFamily: 'Sora', fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
          displaySmall: TextStyle(fontFamily: 'Sora', fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
          headlineLarge: TextStyle(fontFamily: 'Sora', fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
          headlineMedium: TextStyle(fontFamily: 'Sora', fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
          headlineSmall: TextStyle(fontFamily: 'Sora', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
          titleLarge: TextStyle(fontFamily: 'Sora', fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
          titleMedium: TextStyle(fontFamily: 'Sora', fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF1A1A2E)),
          titleSmall: TextStyle(fontFamily: 'Sora', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
          bodyLarge: TextStyle(fontFamily: 'Sora', fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF334155)),
          bodyMedium: TextStyle(fontFamily: 'Sora', fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF475569)),
          bodySmall: TextStyle(fontFamily: 'Sora', fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF64748B)),
          labelLarge: TextStyle(fontFamily: 'Sora', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
          labelMedium: TextStyle(fontFamily: 'Sora', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
          labelSmall: TextStyle(fontFamily: 'Sora', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Sora',
        colorScheme: const ColorScheme.dark(
          primary: primaryLight,
          onPrimary: Color(0xFF1A1A2E),
          primaryContainer: Color(0xFF2D2B5A),
          secondary: accent,
          onSecondary: Color(0xFF1A1A2E),
          surface: Color(0xFF1E1E2E),
          onSurface: Color(0xFFE2E8F0),
          surfaceContainerHighest: Color(0xFF252535),
          outline: Color(0xFF334155),
          error: error,
        ),
        scaffoldBackgroundColor: const Color(0xFF13131F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E2E),
          foregroundColor: Color(0xFFE2E8F0),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Sora',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE2E8F0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryLight,
            foregroundColor: const Color(0xFF1A1A2E),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontFamily: 'Sora', fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF252535),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF334155), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF334155), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryLight, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: error, width: 1.5),
          ),
          labelStyle: const TextStyle(fontFamily: 'Sora', fontSize: 14, color: Color(0xFF94A3B8)),
          hintStyle: const TextStyle(fontFamily: 'Sora', fontSize: 14, color: Color(0xFF475569)),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E1E2E),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF334155), width: 1),
          ),
        ),
      );
}
