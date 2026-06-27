import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this.prefs) : super(ThemeInitial()) {
    emitInitialTheme();
  }
  final SharedPreferences prefs;

  ThemeMode loadTheme() {
    final themeString = prefs.getString('themeMode');
    ThemeMode themeMode;
    switch (themeString) {
      case 'light':
        themeMode = ThemeMode.light;
      case 'dark':
        themeMode = ThemeMode.dark;
      default:
        themeMode = ThemeMode.light;
    }
    return themeMode;
  }

  void emitInitialTheme() {
    final theme = loadTheme();
    emit(ThemeChanged(theme));
  }

  bool getIsDark() => loadTheme() == ThemeMode.dark;

  Future<void> changeTheme(bool isDark) async {
    ThemeMode newThemeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await prefs.setString('themeMode', newThemeMode.name);
    emit(ThemeChanged(newThemeMode));
  }
}
