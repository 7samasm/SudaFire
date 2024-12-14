import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends StateNotifier<bool> {
  ThemeModeNotifier() : super(false);
  toggleMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark_mode', !state);
    state = !state;
  }

  loadDarkMode() async {
    var isDarkMode =
        (await SharedPreferences.getInstance()).getBool('dark_mode') ?? false;
    state = isDarkMode;
  }
}

final ThemeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>(
  (ref) => ThemeModeNotifier(),
);
