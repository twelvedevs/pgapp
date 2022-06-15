import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pgapp/data/models/password_template_model.dart';
import 'package:pgapp/domain/entities/password_template.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final passwordTemplateModel = PasswordTemplateModel(
    passwordLength: 18,
    numberLength: 0,
    symbolLength: 0,
    wordLength: 20,
    randomNumbers: true,
    randomSymbols: true,
    letterCase: LetterCase.lower,
  );

  test(
    'should be a subclass of PasswordTemplate entity',
    () async {
      expect(passwordTemplateModel, isA<PasswordTemplate>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model from JSON',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('password_template.json'));

        final result = PasswordTemplateModel.fromJson(jsonMap);

        expect(result, isA<PasswordTemplateModel>());
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = passwordTemplateModel.toJson();

        final expectedMap = {
          'passwordLength': 18,
          'numberLength': 0,
          'symbolLength': 0,
          'wordLength': 20,
          'randomNumbers': true,
          'randomSymbols': true,
          'letterCase': LetterCase.lower.name,
          'separator': '',
          'md5': false,
          'excludeSymbols': '',
          'includeLetters': true
        };
        expect(result, expectedMap);
      },
    );
  });
}
