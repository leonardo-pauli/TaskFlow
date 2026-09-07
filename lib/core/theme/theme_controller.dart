import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeController extends ChangeNotifier{
  final Box _box;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeController(this._box){
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadTheme() {
    final themeIndex = _box.get('theme_mode', defaultValue: 0);
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  Future<void> changeThemeMode (ThemeMode mode) async {
    _themeMode = mode;
    await _box.put('theme_mode', mode.index);
    notifyListeners();
  }
}