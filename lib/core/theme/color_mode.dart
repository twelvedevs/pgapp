import 'package:flutter/material.dart';
import 'package:pgapp/domain/entities/password_strength_checker.dart';

class MyColors {
  final ColorMode light;
  final ColorMode dark;

  const MyColors({required this.dark, required this.light});
}

class ColorMode {
  final Color primary;
  final Color onPrimary;
  final Color surface;
  final Color surfaceDark;
  final Color surfaceMobile;
  final Color onSurface;
  final Color onSurfaceLight;
  final Color onSurfaceDark;
  final Color background;
  final Color onBackground;
  final Color onBackgroundDark;
  final Color onBackgroundLight;
  final Color success;
  final Color warning;
  final Color error;
  final Color input;
  final Color progressBackground;
  final Color onInput;

  const ColorMode({
    required this.primary,
    required this.onPrimary,
    required this.surface,
    required this.surfaceDark,
    required this.surfaceMobile,
    required this.onSurface,
    required this.onSurfaceLight,
    required this.onSurfaceDark,
    required this.background,
    required this.onBackground,
    required this.onBackgroundDark,
    required this.onBackgroundLight,
    required this.success,
    required this.warning,
    required this.error,
    required this.input,
    required this.progressBackground,
    required this.onInput,
  });

  Color? getColorByStatus(PasswordStrengthCheckerStatus status) {
    if (status == PasswordStrengthCheckerStatus.success) {
      return success;
    }
    if (status == PasswordStrengthCheckerStatus.warning) {
      return warning;
    }
    if (status == PasswordStrengthCheckerStatus.error) {
      return error;
    }

    return null;
  }
}
