import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pgapp/core/utils/crypto.dart';
import 'package:pgapp/data/datasourses/password_template_local_data_source.dart';
import 'package:pgapp/data/repositories/password_template_repository_impl.dart';
import 'package:pgapp/domain/entities/password_generator.dart';
import 'package:pgapp/domain/entities/password_strength_checker.dart';
import 'package:pgapp/domain/entities/password_template.dart';
import 'package:pgapp/domain/repositories/password_template_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordProvider extends ChangeNotifier {
  String _password = '';
  String _md5 = '';
  Map<String, dynamic>? _dictionary;
  final PasswordStrengthChecker _passwordStrengthChecker =
      PasswordStrengthChecker();

  get password => _password;

  get md5 => _md5;

  get score => _passwordStrengthChecker.score;

  get status => _passwordStrengthChecker.status();

  generate(PasswordTemplate passwordTemplate,
      [bool withMd5 = false, bool withNotify = false]) {
    _password = PasswordGenerator(
            passwordTemplate: passwordTemplate, dictionary: _dictionary)
        .generate();

    _passwordStrengthChecker.check(_password);

    if (withMd5) {
      _md5 = generateMd5(_password);
    }

    saveTemplate(passwordTemplate);

    if (withNotify) {
      notifyListeners();
    }
  }

  onMd5() {
    _md5 = generateMd5(_password);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getDictionary(context) async {
    final String value = await DefaultAssetBundle.of(context)
        .loadString("assets/dictionary.json");

    _dictionary = jsonDecode(value);
    return _dictionary!;
  }

  Future<PasswordTemplate?> getTemplate() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      PasswordTemplateLocalDataSource localDataSource =
          PasswordTemplateLocalDataSourceImpl(
              sharedPreferences: sharedPreferences);
      PasswordTemplateRepository repository =
          PasswordTemplateRepositoryImpl(localDataSource: localDataSource);

      return await repository.getLastPasswordTemplate();
    } catch (e) {
      print('PasswordProvider.getTemplate: $e');
      return null;
    }
  }

  Future<void> saveTemplate(PasswordTemplate passwordTemplate) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      PasswordTemplateLocalDataSource localDataSource =
          PasswordTemplateLocalDataSourceImpl(
              sharedPreferences: sharedPreferences);
      PasswordTemplateRepository repository =
          PasswordTemplateRepositoryImpl(localDataSource: localDataSource);

      return repository.setPasswordTemplate(passwordTemplate);
    } catch (e) {
      print('PasswordProvider.saveTemplate: $e');
    }
  }
}
