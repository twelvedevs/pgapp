import 'package:pgapp/core/error/exceptions.dart';
import 'package:pgapp/presentation/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeLocalDataSource {
  Future<Themes> getTheme();

  Future<void> cacheTheme(Themes index);
}

const CACHED_THEME = 'CACHED_THEME';

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Themes> getTheme() {
    final theme = sharedPreferences.getString(CACHED_THEME);

    if (theme != null) {
      return Future.value(Themes.values.byName(theme));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheTheme(Themes theme) {
    return sharedPreferences.setString(CACHED_THEME, theme.name);
  }
}
