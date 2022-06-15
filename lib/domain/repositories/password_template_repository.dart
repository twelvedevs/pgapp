import 'package:pgapp/domain/entities/password_template.dart';

abstract class PasswordTemplateRepository {
  Future<PasswordTemplate> getLastPasswordTemplate();

  Future<void> setPasswordTemplate(PasswordTemplate passwordTemplate);
}
