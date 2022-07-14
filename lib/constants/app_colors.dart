import 'package:flutter/material.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';

class AppColors {

  static Color shortPantsLightColor(bool shortPants) {
    if (SharedPreferencesProvider.darkMode) return const Color(0xFF959595);
    return shortPants ? orange(false) : blue(false);
  }

  static Color shortPantsDarkColorException(bool shortPants) {
    if (SharedPreferencesProvider.darkMode) return const Color(0xFF959595);
    return shortPants ? orange(true) : blue(true);
  }

  static Color shortPantsDarkColor(bool shortPants) {
    if (SharedPreferencesProvider.darkMode) return const Color(0xFF121212);
    return shortPants ? orange(true) : blue(true);
  }

  static Color orange(bool dark) {
    return dark ? const Color(0xFFDE6323) : const Color(0xFFFFC888);
  }

  static Color blue(bool dark) {
    return dark ? const Color(0xFF195F82) : const Color(0xFFBCCBD8);
  }

  static Color green(bool dark) {
    return dark ? const Color(0xFF387932) : const Color(0xFFCFE1CF);
  }

  static Color lighter(bool orange) {
    if (SharedPreferencesProvider.darkMode) return const Color(0xFF282828);
    return orange ? const Color(0xFFFFD4A3) : const Color(0xFFD6DBE0);
  }
}