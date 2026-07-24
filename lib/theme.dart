import 'package:flutter/material.dart';

class AppTheme {
  // Theme Colors
  static const Color background = Color(0xFF070B13);
  static const Color surface = Color(0xFF0F1524);
  static const Color cardBg = Color(0x99182235);
  
  static const Color primary = Color(0xFF00E5FF); // Electric Cyan
  static const Color secondary = Color(0xFF00FF87); // Security Green
  static const Color accent = Color(0xFF7F00FF); // High-tech Violet
  
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color border = Color(0x3300E5FF); // Transparent Cyan border
  
  // Gradients
  static const LinearGradient techGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [background, Color(0xFF0C1424)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Box Decorations
  static BoxDecoration glassCard({
    Color color = cardBg,
    double radius = 16,
    double borderOpacity = 0.2,
    bool showGlow = false,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: primary.withOpacity(borderOpacity),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
        if (showGlow)
          BoxShadow(
            color: primary.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
      ],
    );
  }

  // Text Styles
  static TextStyle headlineStyle({required double size, bool isBold = true}) {
    return TextStyle(
      color: textPrimary,
      fontSize: size,
      fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
    );
  }

  static TextStyle bodyStyle({required double size, bool isSecondary = false}) {
    return TextStyle(
      color: isSecondary ? textSecondary : textPrimary,
      fontSize: size,
      fontFamily: 'Roboto',
      height: 1.5,
    );
  }

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
      ),
      fontFamily: 'Roboto',
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primary,
        selectionColor: Color(0x4D00E5FF),
        selectionHandleColor: primary,
      ),
    );
  }
}
