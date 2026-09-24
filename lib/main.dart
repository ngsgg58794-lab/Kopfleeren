import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() => runApp(const KopfLeerenApp());

class KopfLeerenApp extends StatelessWidget {
  const KopfLeerenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopf leeren',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF1D1C19) : const Color(0xFFE7E4DA);
    final surface = isDark ? const Color(0xFF26241F) : const Color(0xFFF4F2EA);
    final ink = isDark ? const Color(0xFFECE8DD) : const Color(0xFF2B2A26);
    final outline = isDark ? const Color(0xFF9B968A) : const Color(0xFF6B675E);
    final accent = isDark ? const Color(0xFF7FA89C) : const Color(0xFF4B6B63);
    final onAccent = isDark ? const Color(0xFF16211D) : const Color(0xFFF4F2EA);
    final danger = isDark ? const Color(0xFFC97256) : const Color(0xFFA8543F);
    final divider = isDark ? const Color(0xFF3A372F) : const Color(0xFFD6D2C4);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: onAccent,
      secondary: accent,
      onSecondary: onAccent,
      error: danger,
      onError: surface,
      surface: surface,
      onSurface: ink,
      outline: outline,
    );

    final headlineFont = GoogleFonts.fraunces(
      fontWeight: FontWeight.w500,
      letterSpacing: -0.2,
    );
    final bodyFont = GoogleFonts.inter();

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: colorScheme,
      dividerColor: divider,
      textTheme: TextTheme(
        headlineMedium: headlineFont.copyWith(fontSize: 30, color: ink),
        titleMedium: headlineFont.copyWith(fontSize: 17, color: ink),
        bodyMedium: bodyFont.copyWith(fontSize: 15, color: ink, height: 1.4),
        bodySmall: bodyFont.copyWith(fontSize: 12.5, color: outline),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          textStyle:
              bodyFont.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }
}
