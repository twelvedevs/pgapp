import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pgapp/core/theme/color_mode.dart';
import 'package:pgapp/core/theme/theme.dart';
import 'package:pgapp/data/datasourses/theme_local_data_source.dart';
import 'package:pgapp/data/repositories/theme_repository_impl.dart';
import 'package:pgapp/domain/repositories/theme_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Themes { light, dark }

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  ColorMode colorMode =
      SchedulerBinding.instance?.window.platformBrightness == Brightness.dark
          ? MyThemes.colors.dark
          : MyThemes.colors.light;

  ThemeProvider({required Themes? theme}) {
    if (theme == null) {
      return;
    }

    themeMode = theme == Themes.dark ? ThemeMode.dark : ThemeMode.light;
    colorMode =
        theme == Themes.dark ? MyThemes.colors.dark : MyThemes.colors.light;
  }

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance?.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) async {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    colorMode = isOn ? MyThemes.colors.dark : MyThemes.colors.light;
    await saveTheme(isOn ? Themes.dark : Themes.light);
    notifyListeners();
  }

  static Future<Themes?> getTheme() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      ThemeRepository repository = ThemeRepositoryImpl(
          localDataSource:
          ThemeLocalDataSourceImpl(sharedPreferences: sharedPreferences));

      return repository.getTheme();
    } catch (e) {
      print('ThemeProvider.getTheme: $e');
      return null;
    }
  }

  Future<void> saveTheme(Themes theme) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      ThemeRepository repository = ThemeRepositoryImpl(
          localDataSource:
          ThemeLocalDataSourceImpl(sharedPreferences: sharedPreferences));

      return repository.setTheme(theme);
    } catch (e) {
      print('ThemeProvider.saveTheme: $e');
    }
  }
}
