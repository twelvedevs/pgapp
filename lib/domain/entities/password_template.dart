import 'package:pgapp/domain/entities/password_constants.dart';

enum LetterCase { random, upper, lower }

class PasswordTemplate {
  late int _passwordLength;
  late int _numberLength;
  late int _symbolLength;
  late int _wordLength;
  late String _separator;
  bool randomNumbers;
  bool randomSymbols;
  LetterCase letterCase;
  String excludeSymbols;
  bool md5;
  bool includeLetters;

  PasswordTemplate({
    passwordLength = 18,
    numberLength = -1,
    symbolLength = -1,
    wordLength = 0,
    separator = '-',
    this.randomNumbers = true,
    this.randomSymbols = true,
    this.letterCase = LetterCase.random,
    this.md5 = false,
    this.excludeSymbols = '',
    this.includeLetters = true,
  }) {
    _passwordLength = passwordLength;
    _numberLength = numberLength;
    _symbolLength = symbolLength;
    _wordLength = wordLength;
    _separator = separator;
  }

  int requiredPartLength(int numberCount, int symbolCount, int wordCount) {
    final int symbolLength = symbolCount > -1
        ? symbolCount
        : wordCount > 0
            ? wordCount - 1
            : 0;

    return symbolLength +
        (numberCount > 0 ? numberCount : 0) +
        (wordCount * PasswordConstants.min);
  }

  int get passwordLength => _passwordLength;

  set passwordLength(int passwordLength) {
    int requiredPartLength = (symbolLength > -1
            ? symbolLength
            : wordLength > 0
                ? wordLength - 1
                : 0) +
        (numberLength > 0 ? numberLength : 0) +
        (wordLength * PasswordConstants.min);

    if (passwordLength >= requiredPartLength) {
      if (wordLength > 0 &&
          passwordLength >
              requiredPartLength +
                  (PasswordConstants.maxWordLength * wordLength) -
                  (wordLength * PasswordConstants.min)) {
        if (!randomSymbols &&
            separator.isNotEmpty &&
            _symbolLength < wordLength) {
          _symbolLength = wordLength;
        }
        _wordLength++;
      }

      _passwordLength = passwordLength;
      return;
    }

    if (symbolLength > 0 && symbolLength > wordLength - 1) {
      _symbolLength--;
      _passwordLength = passwordLength;
      return;
    }

    if (numberLength > 0) {
      _numberLength--;
      _passwordLength = passwordLength;
      return;
    }

    if (wordLength > 0) {
      _wordLength--;
      _passwordLength = passwordLength;
      return;
    }
  }

  int get numberLength => _numberLength;

  set numberLength(int numberLength) {
    if (numberLength == -1) {
      randomNumbers = true;
      _numberLength = numberLength;
      return;
    }

    int requiredPartLength = (symbolLength > -1
            ? symbolLength
            : wordLength > 0
                ? wordLength - 1
                : 0) +
        (numberLength > 0 ? numberLength : 0) +
        (wordLength * PasswordConstants.min);

    randomNumbers = false;
    _wordLengthChecker(numberLength, symbolLength, wordLength);

    if (requiredPartLength > PasswordConstants.max) {
      return;
    }

    if (requiredPartLength > _passwordLength &&
        requiredPartLength <= PasswordConstants.max) {
      _passwordLength++;
    }

    _numberLength = numberLength;
  }

  int get symbolLength => _symbolLength;

  set symbolLength(int symbolLength) {
    if (symbolLength == -1) {
      randomSymbols = true;
      _symbolLength = symbolLength;
      return;
    }

    if (symbolLength != -1 &&
        separator.isNotEmpty &&
        symbolLength < wordLength - 1) {
      if (symbolLength > _symbolLength) {
        _symbolLength = wordLength - 1;
        return;
      }
      randomSymbols = true;
      _symbolLength = -1;
      return;
    }

    int requiredPartLength = (symbolLength > -1
            ? symbolLength
            : wordLength > 0
                ? wordLength - 1
                : 0) +
        (numberLength > 0 ? numberLength : 0) +
        (wordLength * PasswordConstants.min);

    randomSymbols = false;

    _wordLengthChecker(_numberLength, symbolLength, _wordLength);

    if (requiredPartLength > PasswordConstants.max) {
      return;
    }

    if (requiredPartLength > _passwordLength &&
        requiredPartLength <= PasswordConstants.max) {
      _passwordLength++;
    }

    _symbolLength = symbolLength;
  }

  int get wordLength => _wordLength;

  set wordLength(int wordLength) {
    _wordLengthChecker(numberLength, symbolLength, wordLength);

    if (_symbolLength >= 0 &&
        separator.isNotEmpty &&
        _symbolLength < wordLength - 1) {
      _symbolLength = wordLength - 1;
    }

    int requiredPartLength = (symbolLength > -1
            ? symbolLength
            : wordLength > 0
                ? wordLength - 1
                : 0) +
        (numberLength > 0 ? numberLength : 0) +
        (wordLength * PasswordConstants.min);

    if (requiredPartLength > PasswordConstants.max) {
      return;
    }

    if (requiredPartLength > _passwordLength &&
        requiredPartLength <= PasswordConstants.max) {
      _passwordLength = requiredPartLength;
    }

    _wordLength = wordLength;
  }

  String get separator => _separator;

  set separator(String separator) {
    if (separator.isNotEmpty &&
        symbolLength > -1 &&
        symbolLength + 1 < wordLength) {
      _symbolLength = wordLength - 1;

      int requiredPart =
          requiredPartLength(_numberLength, wordLength - 1, _wordLength);
      if (requiredPart > passwordLength) {
        if (requiredPart <= PasswordConstants.max) {
          _passwordLength = requiredPart;
        } else {
          while (
              requiredPartLength(_numberLength, wordLength - 1, _wordLength) >
                  PasswordConstants.max) {
            _wordLength--;
          }
        }
      }
    }

    _separator = separator;
  }

  _wordLengthChecker(int numberCount, int symbolCount, int wordCount) {
    final max = requiredPartLength(numberCount, symbolCount, wordCount) +
        (PasswordConstants.maxWordLength * wordCount) -
        (wordCount * PasswordConstants.min);

    if (max <= passwordLength &&
        !randomSymbols &&
        !randomNumbers &&
        wordCount > 0) {
      _passwordLength = max;
    }
  }

  @override
  String toString() {
    return '''  
    passwordLength: $passwordLength,
    numberLength: $numberLength,
    symbolLength: $symbolLength,
    wordLength: $wordLength,
    randomNumbers: $randomNumbers,
    randomSymbols: $randomSymbols,
    separator: $separator,
    letterCase: $letterCase,
    excludeSymbols: $excludeSymbols,
    includeLetters: $includeLetters,
    md5: $md5,
    ''';
  }
}
