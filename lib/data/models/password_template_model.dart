import 'package:pgapp/domain/entities/password_template.dart';

class PasswordTemplateModel extends PasswordTemplate {
  PasswordTemplateModel({
    required passwordLength,
    required numberLength,
    required symbolLength,
    required wordLength,
    required randomNumbers,
    required randomSymbols,
    required letterCase,
    separator = '',
    md5 = false,
    excludeSymbols = '',
    includeLetters = true,
  }) : super(
          passwordLength: passwordLength,
          numberLength: numberLength,
          symbolLength: symbolLength,
          wordLength: wordLength,
          randomNumbers: randomNumbers,
          randomSymbols: randomSymbols,
          letterCase: letterCase,
          separator: separator,
          md5: md5,
          excludeSymbols: excludeSymbols,
          includeLetters: includeLetters,
        );

  factory PasswordTemplateModel.fromJson(Map<String, dynamic> json) {
    return PasswordTemplateModel(
      passwordLength: json['passwordLength'],
      numberLength: json['numberLength'],
      symbolLength: json['symbolLength'],
      wordLength: json['wordLength'],
      randomNumbers: json['randomNumbers'],
      randomSymbols: json['randomSymbols'],
      letterCase: LetterCase.values.byName(json['letterCase']),
      separator: json['separator'],
      md5: json['md5'],
      excludeSymbols: json['excludeSymbols'],
      includeLetters: json['includeLetters'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passwordLength': passwordLength,
      'numberLength': numberLength,
      'symbolLength': symbolLength,
      'wordLength': wordLength,
      'randomNumbers': randomNumbers,
      'randomSymbols': randomSymbols,
      'letterCase': letterCase.name,
      'separator': separator,
      'md5': md5,
      'excludeSymbols': excludeSymbols,
      'includeLetters': includeLetters,
    };
  }
}
