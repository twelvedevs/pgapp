import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pgapp/domain/entities/password_generator.dart';
import 'package:pgapp/domain/entities/password_constants.dart';
import 'package:pgapp/domain/entities/password_template.dart';

void main() {
  group('with words', () {
    final passwordTemplate = PasswordTemplate(
        passwordLength: 22,
        numberLength: 0,
        symbolLength: 3,
        wordLength: 4,
        randomNumbers: true,
        randomSymbols: false,
        separator: '-',
        letterCase: LetterCase.random,
        excludeSymbols: '',
        md5: false);

    File file = File('assets/dictionary.json');
    String fileContent = file.readAsStringSync();
    Map<String, dynamic> dictionary = jsonDecode(fileContent);

    test('password length should be equal template password length', () {
      String pass = PasswordGenerator(
              passwordTemplate: passwordTemplate, dictionary: dictionary)
          .generate();

      expect(pass.length, passwordTemplate.passwordLength);
    });

    test('password should be without any symbols', () {
      passwordTemplate.symbolLength = 0;
      passwordTemplate.randomSymbols = false;
      passwordTemplate.separator = '';

      final bool includeSymbols = PasswordGenerator(
              passwordTemplate: passwordTemplate, dictionary: dictionary)
          .generate()
          .split('')
          .any((element) => PasswordConstants.symbols.contains(element));

      expect(includeSymbols, false);
      passwordTemplate.symbolLength = 3;
      passwordTemplate.separator = '-';
    });

    test('password should be without any numbers', () {
      passwordTemplate.numberLength = 0;
      passwordTemplate.randomNumbers = false;

      final bool includeNumbers = PasswordGenerator(
              passwordTemplate: passwordTemplate, dictionary: dictionary)
          .generate()
          .split('')
          .any((element) => PasswordConstants.numbers.contains(element));

      expect(includeNumbers, false);
      passwordTemplate.numberLength = 3;
      passwordTemplate.randomNumbers = true;
    });

    test('password letters should be uppercase', () {
      passwordTemplate.letterCase = LetterCase.upper;

      final bool includeLowercase = PasswordGenerator(
              passwordTemplate: passwordTemplate, dictionary: dictionary)
          .generate()
          .split('')
          .any((element) =>
              PasswordConstants.lowercaseLetters.contains(element));

      expect(includeLowercase, false);
    });

    test('password letters should be lowercase', () {
      passwordTemplate.letterCase = LetterCase.lower;

      final bool includeUppercase = PasswordGenerator(
              passwordTemplate: passwordTemplate, dictionary: dictionary)
          .generate()
          .split('')
          .any((element) =>
              PasswordConstants.uppercaseLetters.contains(element));

      expect(includeUppercase, false);
    });
  });

  group('without words', () {
    final passwordTemplate = PasswordTemplate(
        passwordLength: 10,
        numberLength: 3,
        symbolLength: 3,
        wordLength: 0,
        randomNumbers: false,
        randomSymbols: false,
        separator: '',
        letterCase: LetterCase.random,
        excludeSymbols: '',
        md5: false);

    test('password length should be equal template password length', () {
      String pass =
          PasswordGenerator(passwordTemplate: passwordTemplate).generate();

      expect(pass.length, passwordTemplate.passwordLength);
    });

    test('password should be without any symbols', () {
      passwordTemplate.symbolLength = 0;

      final bool includeSymbols =
          PasswordGenerator(passwordTemplate: passwordTemplate)
              .generate()
              .split('')
              .any((element) => PasswordConstants.symbols.contains(element));

      expect(includeSymbols, false);
      passwordTemplate.symbolLength = 3;
    });

    test('password should be without any numbers', () {
      passwordTemplate.numberLength = 0;

      final bool includeNumbers =
          PasswordGenerator(passwordTemplate: passwordTemplate)
              .generate()
              .split('')
              .any((element) => PasswordConstants.numbers.contains(element));

      expect(includeNumbers, false);
      passwordTemplate.numberLength = 3;
    });

    test('password letters should be uppercase', () {
      passwordTemplate.letterCase = LetterCase.upper;

      final bool includeLowercase =
          PasswordGenerator(passwordTemplate: passwordTemplate)
              .generate()
              .split('')
              .any((element) =>
                  PasswordConstants.lowercaseLetters.contains(element));

      expect(includeLowercase, false);
    });

    test('password letters should be lowercase', () {
      passwordTemplate.letterCase = LetterCase.lower;

      final bool includeUppercase =
          PasswordGenerator(passwordTemplate: passwordTemplate)
              .generate()
              .split('')
              .any((element) =>
                  PasswordConstants.uppercaseLetters.contains(element));

      expect(includeUppercase, false);
    });

    // test('generated password part should be without excludeSymbols', () {
    //   passwordTemplate.excludeSymbols = '%@#^&*><.,';
    //
    //   final bool includeExcludeSymbols = PasswordGenerator(
    //           passwordTemplate: passwordTemplate)
    //       .generate()
    //       .substring(0, passwordTemplate.beginWith.length)
    //       .split('')
    //       .any((element) => passwordTemplate.excludeSymbols.contains(element));
    //
    //   expect(includeExcludeSymbols, false);
    //   passwordTemplate.excludeSymbols = '';
    // });
  });
}
