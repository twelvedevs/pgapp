import 'dart:math';

enum PasswordStrengthCheckerStatus { success, warning, error }

class PasswordStrengthChecker {
  double _score = 0;

  get score => _score;

  PasswordStrengthCheckerStatus status() {
    if (_score < 0.3) {
      return PasswordStrengthCheckerStatus.error;
    }
    if (_score < 0.6) {
      return PasswordStrengthCheckerStatus.warning;
    }

    return PasswordStrengthCheckerStatus.success;
  }

  double check(String password) {
    _score = 0;
    _score = _estimateBruteforceStrength(password);

    return _score;
  }

  double _estimateBruteforceStrength(String password) {
    if (password.isEmpty) return 0.0;

    double charsetBonus;
    if (RegExp(r'^[0-9]*$').hasMatch(password)) {
      charsetBonus = 0.8 / 1.5;
    } else if (RegExp(r'^[a-z]*$').hasMatch(password)) {
      charsetBonus = 1.0 / 1.5;
    } else if (RegExp(r'^[a-z0-9]*$').hasMatch(password)) {
      charsetBonus = 1.2 / 1.5;
    } else if (RegExp(r'^[a-zA-Z]*$').hasMatch(password)) {
      charsetBonus = 1.3 / 1.5;
    } else if (RegExp(r'^[a-z\-_!?]*$').hasMatch(password)) {
      charsetBonus = 1.3 / 1.5;
    } else if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch(password)) {
      charsetBonus = 1.5 / 1.5;
    } else {
      charsetBonus = 1.8 / 1.5;
    }

    logisticFunction(double x) {
      return 1.0 / (1.0 + exp(-x));
    }

    curve(double x) {
      return logisticFunction((x / 3.0) - 4.0);
    }

    return curve(password.length * charsetBonus);
  }
}
