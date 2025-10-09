import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService extends BaseViewModel {
  static const _favKey = 'favorites_v1';
  static const _themeKey = 'isDarkMode';

  SharedPreferences? _prefs;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<String>> getAll() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getStringList(_favKey) ?? [];
  }

  Future<void> add(String item) async {
    _prefs ??= await SharedPreferences.getInstance();
    final list = _prefs!.getStringList(_favKey) ?? [];
    if (!list.contains(item)) {
      list.add(item);
      await _prefs!.setStringList(_favKey, list);
    }
  }

  Future<void> remove(String item) async {
    _prefs ??= await SharedPreferences.getInstance();
    final list = _prefs!.getStringList(_favKey) ?? [];
    list.remove(item);
    await _prefs!.setStringList(_favKey, list);
  }

  Future<bool> contains(String item) async {
    _prefs ??= await SharedPreferences.getInstance();
    final list = _prefs!.getStringList(_favKey) ?? [];
    return list.contains(item);
  }

  /// Save theme preference
  Future<void> saveTheme(bool isDark) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(_themeKey, isDark);
  }

  /// Load saved theme preference
  Future<ThemeMode> getThemeMode() async {
    _prefs ??= await SharedPreferences.getInstance();
    final isDark = _prefs!.getBool(_themeKey) ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  ///
  /// THEME RELATED
  ///

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  PreferenceService() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme(bool dark) async {
    _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', dark);
  }
}
