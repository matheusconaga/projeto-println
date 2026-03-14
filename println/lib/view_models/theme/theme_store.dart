import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  static const _prefKey = 'isDarkMode';

  @observable
  bool isDarkMode = false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool(_prefKey) ?? false;
  }

  @action
  Future<void> toggleTheme(bool value) async {
    isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);
  }
}