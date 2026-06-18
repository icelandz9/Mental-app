import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===== ระบบสีกลางของแอป (Calm Wellness — Indigo & Mint) =====
/// ใช้ร่วมกันทุกหน้าเพื่อให้โทนสีสม่ำเสมอ อบอุ่น และดูพรีเมียม
class AppColors {
  AppColors._();

  // สีหลัก (อินดิโกนุ่ม)
  static const Color primary = Color(0xFF6B6FD6);
  static const Color primaryDark = Color(0xFF565AC0);

  // สีรอง
  static const Color accent = Color(0xFF4FB7A0); // มินต์
  static const Color peach = Color(0xFFF1A98C); // พีชอบอุ่น

  // พื้นผิว / ข้อความ
  static const Color bg = Color(0xFFF4F5FB); // พื้นหลังแอป
  static const Color surface = Color(0xFFFFFFFF); // พื้นการ์ด
  static const Color textPrimary = Color(0xFF2B2D42);
  static const Color textSecondary = Color(0xFF6E7180);
  static const Color border = Color(0xFFE6E8F2);

  // สีระดับความรุนแรง (ใช้ในหน้าผลลัพธ์)
  static const Color green = Color(0xFF2E9E6B);
  static const Color lime = Color(0xFF7CB342);
  static const Color orange = Color(0xFFF59E2E);
  static const Color deepOrange = Color(0xFFE9743B);
  static const Color red = Color(0xFFE05656);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.bg,
    );

    return base.copyWith(
      textTheme: GoogleFonts.notoSansThaiTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
      ),
    );
  }
}
