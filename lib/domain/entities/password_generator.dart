import 'dart:math';

import 'package:pgapp/domain/entities/password_constants.dart';
import 'package:pgapp/domain/entities/password_template.dart';

class PasswordGenerator {
  final PasswordTemplate passwordTemplate;
  final Map<String, dynamic>? dictionary;

  PasswordGenerator({
    required this.passwordTemplate,
    this.dictionary = const {},
  });

  String _getCharset() {
    String chars = '';

    if (passwordTemplate.includeLetters) {
      if (passwordTemplate.letterCase != LetterCase.upper) {
        chars += PasswordConstants.lowercaseLetters;
      }

      if (passwordTemplate.letterCase != LetterCase.lower) {
        chars += PasswordConstants.uppercaseLetters;
      }
    }

    if (passwordTemplate.randomNumbers) {
      chars += PasswordConstants.numbers;
    }

    if (passwordTemplate.randomSymbols) {
      chars += PasswordConstants.symbols;
    }

    return chars;
  }

  String _getFilteredCharset(String charset) {
    final Set<String> set = charset.split('').toSet();

    passwordTemplate.excludeSymbols.split('').forEach((el) {
      if (set.contains(el)) {
        set.remove(el);
      }
    });

    final charsetFiltered = set.join('');

    if (charsetFiltered.isEmpty) {
      throw Exception('Empty charset');
    }

    return charsetFiltered;
  }

  List<int> _createWordLengths(int maxLength, int wordCount) {
    const minLength = PasswordConstants.min;
    List<int> wordLengths = List.generate(wordCount, (index) => minLength);
    final int addCountMax = maxLength - (wordCount * minLength);

    if (addCountMax == 0) {
      return wordLengths;
    }

    final int addCount =
        passwordTemplate.randomSymbols || passwordTemplate.randomNumbers
            ? Random().nextInt(addCountMax)
            : addCountMax;

    for (int i = 0; i < addCount; i++) {
      final int position = Random().nextInt(wordCount);
      wordLengths[position] = wordLengths[position] + 1;
    }

    return wordLengths;
  }

  String _generateWithoutWords() {
    List<String> password =
        List.generate(passwordTemplate.passwordLength, (index) => '');
    final String charset = _getCharset();
    final List<int> indexList =
        List.generate(passwordTemplate.passwordLength, (index) => index);

    if (passwordTemplate.numberLength > 0 && !passwordTemplate.randomNumbers) {
      for (int i = 0; i < passwordTemplate.numberLength; i++) {
        final int indexesPosition = Random().nextInt(indexList.length);
        final int charsetPosition =
            Random().nextInt(PasswordConstants.numbers.length);
        password[indexList[indexesPosition]] = PasswordConstants.numbers
            .substring(charsetPosition, charsetPosition + 1);
        indexList.remove(indexList[indexesPosition]);
      }
    }

    if (passwordTemplate.symbolLength > 0 && !passwordTemplate.randomSymbols) {
      for (int i = 0; i < passwordTemplate.symbolLength; i++) {
        final int indexesPosition = Random().nextInt(indexList.length);
        final int charsetPosition =
            Random().nextInt(PasswordConstants.symbols.length);
        password[indexList[indexesPosition]] = PasswordConstants.symbols
            .substring(charsetPosition, charsetPosition + 1);
        indexList.remove(indexList[indexesPosition]);
      }
    }

    while (indexList.isNotEmpty) {
      final int indexesPosition = Random().nextInt(indexList.length);
      final int charsetPosition = Random().nextInt(charset.length);
      final char = charset.substring(charsetPosition, charsetPosition + 1);
      password[indexList[indexesPosition]] = char;
      indexList.remove(indexList[indexesPosition]);
    }

    return password.join('');
  }

  String _generateWithWords() {
    if (dictionary == null) {
      return throw Exception('Dictionary is empty');
    }

    String password = '';

    final int necessaryNumberLength =
        passwordTemplate.randomNumbers ? 0 : passwordTemplate.numberLength;

    final int necessarySymbolLength =
        passwordTemplate.randomSymbols ? 0 : passwordTemplate.symbolLength;

    final int necessaryWordSymbolLength =
        passwordTemplate.randomSymbols ? passwordTemplate.wordLength - 1 : 0;

    final int maxLength = passwordTemplate.passwordLength -
        necessarySymbolLength -
        necessaryNumberLength -
        necessaryWordSymbolLength;

    final List<int> wordLengths =
        _createWordLengths(maxLength, passwordTemplate.wordLength);

    final List words = [];

    for (int element in wordLengths) {
      int key = element;

      while (!dictionary!.keys.contains(key.toString()) &&
          key > PasswordConstants.min) {
        key--;
      }

      List wordList = dictionary![key.toString()];
      int position = Random().nextInt(wordList.length);
      words.add(wordList[position]);
    }

    final String wordsPartOfPassword = words.join(passwordTemplate.separator);

    final int separatorCommonLength = (words.length -
        ((words.length * passwordTemplate.separator.length) -
            passwordTemplate.separator.length));

    final PasswordTemplate tailPasswordTemplate = PasswordTemplate(
        passwordLength: necessaryNumberLength +
            (necessarySymbolLength > 0
                ? necessarySymbolLength - (words.length - separatorCommonLength)
                : 0),
        numberLength: necessaryNumberLength,
        symbolLength: necessarySymbolLength > 0
            ? necessarySymbolLength - (words.length - separatorCommonLength)
            : 0,
        wordLength: 0,
        randomNumbers: false,
        randomSymbols: false,
        includeLetters: false,
        letterCase: passwordTemplate.letterCase);

    String tail =
        PasswordGenerator(passwordTemplate: tailPasswordTemplate).generate();

    password = wordsPartOfPassword + tail;

    if (passwordTemplate.passwordLength - password.length > 0) {
      tailPasswordTemplate.numberLength = 0;
      tailPasswordTemplate.symbolLength = 0;
      tailPasswordTemplate.randomNumbers = passwordTemplate.randomNumbers;
      tailPasswordTemplate.randomSymbols = passwordTemplate.randomSymbols;
      tailPasswordTemplate.passwordLength =
          passwordTemplate.passwordLength - password.length;

      tail =
          PasswordGenerator(passwordTemplate: tailPasswordTemplate).generate();

      password += tail;
    }

    if (passwordTemplate.letterCase == LetterCase.upper) {
      password = password.toUpperCase();
    }

    return password;
  }

  String generate() {
    if (passwordTemplate.wordLength > 0) {
      return _generateWithWords();
    }

    return _generateWithoutWords();
  }
}
