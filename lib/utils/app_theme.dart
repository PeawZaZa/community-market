import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF1A3A2A);
  static const Color primaryLight = Color(0xFF2D6A4A);
  static const Color primaryAccent = Color(0xFF1D9E75);
  static const Color primarySoft = Color(0xFF5DCAA5);
  static const Color primaryPale = Color(0xFFE1F5EE);
  static const Color primaryMid = Color(0xFF9FE1CB);
  static const Color secondary = Color(0xFFD85A30);
  static const Color surface = Color(0xFFF8F9F6);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF1A2E22);
  static const Color textSecondary = Color(0xFF5F7A6A);
  static const Color textHint = Color(0xFF9AB5A5);
  static const Color border = Color(0xFFD8E8E0);
  static const Color divider = Color(0xFFEEF5F0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surface,
      ),
      scaffoldBackgroundColor: surface,
      fontFamily: GoogleFonts.sarabun().fontFamily,
      textTheme: GoogleFonts.sarabunTextTheme().copyWith(
        displayLarge: GoogleFonts.sarabun(fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary),
        headlineMedium: GoogleFonts.sarabun(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
        titleLarge: GoogleFonts.sarabun(fontSize: 17, fontWeight: FontWeight.w600, color: textPrimary),
        titleMedium: GoogleFonts.sarabun(fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary),
        bodyLarge: GoogleFonts.sarabun(fontSize: 15, fontWeight: FontWeight.w400, color: textPrimary),
        bodyMedium: GoogleFonts.sarabun(fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sarabun(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.sarabun(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F7F3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border, width: 1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryAccent, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.sarabun(color: textHint, fontSize: 14),
        labelStyle: GoogleFonts.sarabun(color: textSecondary, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryPale,
        selectedColor: primary,
        labelStyle: GoogleFonts.sarabun(fontSize: 12, color: textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle: GoogleFonts.sarabun(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1, space: 1),
    );
  }
}

class AppConstants {
  static const String appName = 'ตลาดชุมชน';
  static const String dbName = 'community_market.db';
  static const int dbVersion = 1;

  static const List<Map<String, dynamic>> categories = [
    {'id': 'all', 'name': 'ทั้งหมด', 'icon': '🏪'},
    {'id': 'vegetables', 'name': 'ผักผลไม้', 'icon': '🥬'},
    {'id': 'food', 'name': 'อาหาร', 'icon': '🍜'},
    {'id': 'handicraft', 'name': 'หัตถกรรม', 'icon': '🧺'},
    {'id': 'clothing', 'name': 'เสื้อผ้า', 'icon': '👗'},
    {'id': 'herbs', 'name': 'สมุนไพร', 'icon': '🌿'},
    {'id': 'other', 'name': 'อื่นๆ', 'icon': '📦'},
  ];

  static const String defaultUserId = 'user_001';
  static const String defaultUserName = 'สมชาย ใจดี';
  static const String defaultUserLocation = 'แม่ริม, เชียงใหม่';
}
