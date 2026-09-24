import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

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
      home: const SplashScreen(next: HomeScreen()),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0B1B2A) : const Color(0xFFF3F8FC);
    final surface = isDark ? const Color(0xFF12283D) : const Color(0xFFFFFFFF);
    final ink = isDark ? const Color(0xFFE8F1F8) : const Color(0xFF0E2A40);
    final outline = isDark ? const Color(0xFF8AA6BD) : const Color(0xFF5A7489);
    final accent = isDark ? const Color(0xFF5DB2E3) : const Color(0xFF1668A6);
    final onAccent = isDark ? const Color(0xFF06202F) : const Color(0xFFFFFFFF);
    final danger = isDark ? const Color(0xFFF07A86) : const Color(0xFFC9424F);
    final divider = isDark ? const Color(0xFF1F3B55) : const Color(0xFFDCE7F0);

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

    final headlineFont = GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
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
