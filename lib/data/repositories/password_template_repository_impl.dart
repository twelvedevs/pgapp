import 'package:pgapp/data/datasourses/password_template_local_data_source.dart';
import 'package:pgapp/data/models/password_template_model.dart';
import 'package:pgapp/domain/entities/password_template.dart';
import 'package:pgapp/domain/repositories/password_template_repository.dart';

class PasswordTemplateRepositoryImpl extends PasswordTemplateRepository {
  final PasswordTemplateLocalDataSource localDataSource;

  PasswordTemplateRepositoryImpl({required this.localDataSource});

  @override
  Future<PasswordTemplate> getLastPasswordTemplate() async {
    return await localDataSource.getPasswordTemplate();
  }

  @override
  Future<void> setPasswordTemplate(PasswordTemplate passwordTemplate) async {
    PasswordTemplateModel passwordTemplateModel = PasswordTemplateModel(
        passwordLength: passwordTemplate.passwordLength,
        numberLength: passwordTemplate.numberLength,
        symbolLength: passwordTemplate.symbolLength,
        wordLength: passwordTemplate.wordLength,
        randomNumbers: passwordTemplate.randomNumbers,
        randomSymbols: passwordTemplate.randomSymbols,
        letterCase: passwordTemplate.letterCase,
        separator: passwordTemplate.separator,
        md5: passwordTemplate.md5,
        includeLetters: passwordTemplate.includeLetters,
        excludeSymbols: passwordTemplate.excludeSymbols,
    );

    await localDataSource.cachePasswordTemplate(passwordTemplateModel);
  }
}
