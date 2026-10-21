import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette from Figma Color Palette Frame
  static const Color primaryDark = Color(0xFF17152B);
  static const Color primaryPurple = Color(0xFF6B48FC);
  static const Color secondaryPurple = Color(0xFF7254F0);
  static const Color accentPastel = Color(0xFFC6BCFF);
  static const Color accentSoft = Color(0xFFECE8FF);
  static const Color accentUltraLight = Color(0xFFF7F6FF);
  static const Color white = Color(0xFFFFFFFF);
  
  // Accents & Badges
  static const Color goldYellow = Color(0xFFFFD700);
  static const Color successGreen = Color(0xFF28A745);
  static const Color softGreen = Color(0xFFE8F5E9);
  static const Color verifiedCyan = Color(0xFF20C997);
  static const Color dangerRed = Color(0xFFE33629);
  
  // Neutrals
  static const Color textDark = Color(0xFF17152B);
  static const Color textMuted = Color(0xFF6C727F);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color dividerColor = Color(0xFFEDE9FE);
  
  // Gradients
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF8B6BFD), Color(0xFF6B48FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF8763FD), Color(0xFF6A46FC), Color(0xFF5532E9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient softCardGradient = LinearGradient(
    colors: [Color(0xFFEDE8FF), Color(0xFFDCD5FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
