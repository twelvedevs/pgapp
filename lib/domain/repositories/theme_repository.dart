import 'package:pgapp/presentation/providers/theme_provider.dart';

abstract class ThemeRepository {
  Future<Themes> getTheme();

  Future<void> setTheme(Themes theme);
}
