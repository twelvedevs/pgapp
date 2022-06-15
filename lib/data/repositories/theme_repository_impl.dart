import 'package:pgapp/data/datasourses/theme_local_data_source.dart';
import 'package:pgapp/domain/repositories/theme_repository.dart';
import 'package:pgapp/presentation/providers/theme_provider.dart';

class ThemeRepositoryImpl extends ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<Themes> getTheme() {
    return localDataSource.getTheme();
  }

  @override
  Future<void> setTheme(Themes theme) {
    return localDataSource.cacheTheme(theme);
  }
}
