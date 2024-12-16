import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode { light, dark }

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);
  get isDark => state == ThemeMode.dark;
  toggleMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark_mode', isDark);
    state = !isDark ? ThemeMode.dark : ThemeMode.light;
  }

  loadDarkMode() async {
    var isDark =
        (await SharedPreferences.getInstance()).getBool('dark_mode') ?? false;
    state = !isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);
