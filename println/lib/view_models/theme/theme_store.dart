import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  static const _prefKey = 'isDarkMode';

  @observable
  ThemeMode themeMode = ThemeMode.system;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_prefKey);

    if (value == null) {
      themeMode = ThemeMode.system;
    } else {
      themeMode = ThemeMode.values.firstWhere(
            (e) => e.name == value,
        orElse: () => ThemeMode.system,
      );
    }
  }

  @action
  Future<void> setTheme(ThemeMode mode) async {
    themeMode = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, mode.name);
  }

  bool isDark(BuildContext context) {
    if (themeMode == ThemeMode.system) {
      final brightness = MediaQuery.of(context).platformBrightness;
      return brightness == Brightness.dark;
    }

    return themeMode == ThemeMode.dark;
  }

}