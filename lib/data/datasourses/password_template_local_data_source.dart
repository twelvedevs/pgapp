import 'dart:convert';

import 'package:pgapp/core/error/exceptions.dart';
import 'package:pgapp/data/models/password_template_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PasswordTemplateLocalDataSource {
  /// Gets the cached [PasswordTemplateModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<PasswordTemplateModel> getPasswordTemplate();

  Future<void> cachePasswordTemplate(PasswordTemplateModel passwordTemplate);
}

const CACHED_PASSWORD_TEMPLATE = 'CACHED_PASSWORD_TEMPLATE';

class PasswordTemplateLocalDataSourceImpl implements PasswordTemplateLocalDataSource {
  final SharedPreferences sharedPreferences;

  PasswordTemplateLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<PasswordTemplateModel> getPasswordTemplate() {
    final jsonString = sharedPreferences.getString(CACHED_PASSWORD_TEMPLATE);
    if (jsonString != null) {
      return Future.value(
          PasswordTemplateModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePasswordTemplate(PasswordTemplateModel passwordTemplate) {
    return sharedPreferences.setString(
      CACHED_PASSWORD_TEMPLATE,
      json.encode(passwordTemplate.toJson()),
    );
  }
}
