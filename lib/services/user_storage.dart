import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const _keyAge = 'user_age';
  static const _keyHair = 'user_hair';
  static const _keyColor = 'user_color';
  static const _keyTheme = 'user_theme'; // 0=system,1=light,2=dark

  // Save age
  static Future<void> saveAge(int age) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAge, age);
  }

  // Load age (null if none)
  static Future<int?> loadAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyAge) ? prefs.getInt(_keyAge) : null;
  }

  // Save customization choices
  static Future<void> saveCustomization({required int hairIndex, required Color color}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyHair, hairIndex);
    await prefs.setInt(_keyColor, color.toARGB32());
  }

  // Load customization (returns defaults if missing)
  static Future<Map<String, dynamic>> loadCustomization() async {
    final prefs = await SharedPreferences.getInstance();
    final hair = prefs.getInt(_keyHair) ?? 0;
    final colorValue = prefs.getInt(_keyColor) ?? Colors.green.toARGB32();
    return {'hairIndex': hair, 'color': Color(colorValue)};
  }

  // Theme persistence
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final int v = mode == ThemeMode.system ? 0 : (mode == ThemeMode.light ? 1 : 2);
    await prefs.setInt(_keyTheme, v);
  }

  static Future<ThemeMode?> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyTheme)) return null;
    final v = prefs.getInt(_keyTheme);
    if (v == 0) return ThemeMode.system;
    if (v == 1) return ThemeMode.light;
    return ThemeMode.dark;
  }

  // Clear profile (for sign out / testing)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAge);
    await prefs.remove(_keyHair);
    await prefs.remove(_keyColor);
    await prefs.remove(_keyTheme);
  }
}