import 'package:flutter/material.dart';
import 'package:pgapp/core/theme/color_mode.dart';

class MyDimensions {
  static int mobile = 768;
  static int small = 382;
}

class MyThemes {
  static const Duration duration = Duration(milliseconds: 250);

  static MyColors colors = MyColors(
      dark: ColorMode(
          primary: const Color(0xFF404E62),
          onPrimary: const Color(0xFFFFFFFF),
          surface: const Color(0xFF000000).withOpacity(0.2),
          surfaceDark: const Color(0xFF798392),
          surfaceMobile: const Color(0xFFFFFFFF).withOpacity(0.05),
          onSurface: const Color(0xFFFFFFFF),
          onSurfaceLight: const Color(0xFFBFC1C5),
          onSurfaceDark: const Color(0xFFFFFFFF),
          background: const Color(0xFFFFFFFF).withOpacity(0.15),
          onBackground: const Color(0xFFFFFFFF),
          onBackgroundDark: const Color(0xFF798392),
          onBackgroundLight: const Color(0xFFFFFFFF),
          success: const Color(0xFF04CC9A),
          warning: const Color(0xFFFFAE64),
          error: const Color(0xFFCD3656),
          input: const Color(0xFF798392),
          progressBackground: const Color(0xFF798392),
          onInput: const Color(0xFFFFFFFF)),
      light: ColorMode(
          primary: const Color(0xFFFFFFFF),
          onPrimary: const Color(0xFF19374D),
          surface: const Color(0xFF7091A6).withOpacity(0.45),
          surfaceDark: const Color(0xFFC5D5DE),
          surfaceMobile: const Color(0xFF7091A6).withOpacity(0.3),
          onSurface: const Color(0xFFFFFFFF),
          onSurfaceLight: const Color(0xFF708796),
          onSurfaceDark: const Color(0xFF19374D),
          background: const Color(0xFFFFFFFF).withOpacity(0.15),
          onBackground: const Color(0xFFFFFFFF),
          onBackgroundDark: const Color(0xFF19374D),
          onBackgroundLight: const Color(0xFFFFFFFF),
          success: const Color(0xFF97F9C6),
          warning: const Color(0xFFFFDEA0),
          error: const Color(0xFFF99797),
          input: const Color(0xFFFFFFFF),
          progressBackground: const Color(0xFFFFFFFF),
          onInput: const Color(0xFF19374D)));

  static LinearGradient backgroundGradient(bool isDarkMode) => isDarkMode
      ? const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff015480),
      Color(0xff00224d),
      Color(0xff00224d),
      Color(0xff650c46),
    ],
  )
      : const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffcad0d5),
      Color(0xffbac5ce),
      Color(0xffbac5cd),
      Color(0xff8ca8b9),
    ],
  );

  static final darkTheme = ThemeData.dark().copyWith(
    textTheme: const TextTheme().copyWith(
        headline1: TextStyle(
          leadingDistribution: TextLeadingDistribution.even,
          fontFamily: 'Manrope',
          fontSize: 40,
          fontWeight: FontWeight.w600,
          height: 1.37,
          color: colors.dark.onBackgroundLight,
        ),
        headline2: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: colors.dark.onBackgroundLight,
        ),
        headline3: TextStyle(
          leadingDistribution: TextLeadingDistribution.even,
          fontFamily: 'Manrope',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: colors.dark.onBackgroundLight,
        ),
        headline4: TextStyle(
          leadingDistribution: TextLeadingDistribution.even,
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: colors.dark.onBackgroundLight,
        ),
        bodyText1: TextStyle(
          leadingDistribution: TextLeadingDistribution.even,
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 2,
          color: colors.dark.onPrimary,
        ),
        bodyText2: TextStyle(
          leadingDistribution: TextLeadingDistribution.even,
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 2.5,
          color: colors.dark.onPrimary,
        ),
        subtitle1: TextStyle(
          fontFamily: 'Manrope',
          color: colors.dark.onInput,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        caption: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 2.2,
          leadingDistribution: TextLeadingDistribution.even,
          color: colors.dark.onSurface,
        )),
    inputDecorationTheme: const InputDecorationTheme().copyWith(
      fillColor: colors.dark.input,
      contentPadding: const EdgeInsets.only(left: 16),
      filled: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          )),
    ),
  );

  static final lightTheme = ThemeData.light().copyWith(
    textTheme: const TextTheme().copyWith(
      headline1: MyThemes.darkTheme.textTheme.headline1?.copyWith(
        color: colors.light.onBackgroundDark,
      ),
      headline2: MyThemes.darkTheme.textTheme.headline2?.copyWith(
        color: colors.light.onBackgroundDark,
      ),
      headline3: MyThemes.darkTheme.textTheme.headline3?.copyWith(
        color: colors.light.onBackgroundDark,
      ),
      headline4: MyThemes.darkTheme.textTheme.headline4?.copyWith(
        color: colors.light.onBackgroundDark,
      ),
      bodyText1: MyThemes.darkTheme.textTheme.bodyText1?.copyWith(
        color: colors.light.onPrimary,
      ),
      bodyText2: MyThemes.darkTheme.textTheme.bodyText2?.copyWith(
        color: colors.light.onPrimary,
      ),
      subtitle1: MyThemes.darkTheme.textTheme.subtitle1?.copyWith(
        color: colors.light.onInput,
      ),
      caption: MyThemes.darkTheme.textTheme.caption?.copyWith(
        color: colors.light.onSurface,
      ),
    ),
    inputDecorationTheme: MyThemes.darkTheme.inputDecorationTheme.copyWith(
      fillColor: colors.light.input,
    ),
  );
}
