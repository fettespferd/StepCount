import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class AppColors {
  static MaterialColor primary(Brightness brightness) =>
      brightness.isLight ? primaryLight : primaryDark;
  static const primaryLight = MaterialColor(0xFFD72E8B, {
    50: Color(0xFFF7A56C),
    100: Color(0xFFD98A53),
    200: Color(0xFFBB713B),
    300: Color(0xFF9E5823),
    400: Color(0xFF814009),
    500: Color(0xFF652900),
    600: Color(0xFF491300),
    700: Color(0xFF2F0000),
    800: Color(0xFF040000),
    900: Color(0xFF000000),
  });
  static const primaryDark = MaterialColor(0xFF962061, {
    50: Color(0xFFD9691A),
    100: Color(0xFFBA4F00),
    200: Color(0xFF9B3600),
    300: Color(0xFF7C1C00),
    400: Color(0xFF5E0000),
    500: Color(0xFF420000),
    600: Color(0xFF280001),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  });
  static Color primaryVariant(Brightness brightness) =>
      brightness.isLight ? primaryVariantLight : primaryVariantDark;
  static const primaryVariantLight = Color(0xFFF7A56C);
  static const primaryVariantDark = Color(0xFF9E5823);

  static MaterialColor secondary(Brightness brightness) =>
      brightness.isLight ? secondaryLight : secondaryLight;
  static const secondaryLight = MaterialColor(0xFFA32B82, {
    50: Color(0xFFC48F6A),
    100: Color(0xFFA87552),
    200: Color(0xFF8C5D3A),
    300: Color(0xFF714524),
    400: Color(0xFF562E0E),
    500: Color(0xFF3D1900),
    600: Color(0xFF250100),
    700: Color(0xFF170000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  });
  static const secondaryDark = MaterialColor(0xFF711E5A, {
    50: Color(0xFFB09C8F),
    100: Color(0xFF958275),
    200: Color(0xFF7B695D),
    300: Color(0xFF625145),
    400: Color(0xFF4A3A2F),
    500: Color(0xFF33241A),
    600: Color(0xFF1F0F00),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  });
  static Color secondaryVariant(Brightness brightness) =>
      brightness.isLight ? secondaryVariantLight : secondaryVariantLight;
  static const secondaryVariantLight = Color(0xFFC48F6A);
  static const secondaryVariantDark = Color(0xFFB09C8F);

  static Color surface(Brightness brightness) =>
      brightness.isLight ? surfaceLight : surfaceDark;
  static const surfaceLight = Colors.white;
  static const surfaceDark = Color(0xFF121212);

  static Color background(Brightness brightness) =>
      brightness.isLight ? backgroundLight : backgroundDark;
  static const backgroundLight = Color(0xFFEFEFEF);
  static const backgroundDark = Color(0xFF121212);

  static Color error(Brightness brightness) =>
      brightness.isLight ? errorLight : errorDark;
  static const errorLight = Color(0xFF250100);
  static const errorDark = Color(0xFF33241A);

  static ColorScheme primaryScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: primary(brightness),
      primaryVariant: primaryVariant(brightness),
      onPrimary: primary(brightness).highEmphasisOnColor,
      secondary: brightness.isDark ? Colors.white : secondary(brightness),
      secondaryVariant:
          brightness.isDark ? Colors.white : secondaryVariant(brightness),
      onSecondary: brightness.isDark
          ? Colors.black
          : secondary(brightness).highEmphasisOnColor,
      surface: surface(brightness),
      onSurface: surface(brightness).highEmphasisOnColor,
      background: background(brightness),
      onBackground: background(brightness).highEmphasisOnColor,
      error: error(brightness),
      onError: error(brightness).highEmphasisOnColor,
    );
  }

  static ColorScheme secondaryScheme(Brightness brightness) {
    final secondary = AppColors.secondary(brightness);
    final primary = secondary.highEmphasisOnColor;
    return ColorScheme(
      brightness: brightness,
      primary: MaterialColor(primary.value, {
        50: primary,
        100: primary,
        200: primary,
        300: primary,
        400: primary,
        500: primary,
        600: primary,
        700: primary,
        800: primary,
        900: primary,
      }),
      primaryVariant: secondary.highEmphasisOnColor,
      onPrimary: secondary.estimatedBrightness.highEmphasisColor,
      secondary: secondary.highEmphasisOnColor,
      secondaryVariant: secondary.highEmphasisOnColor,
      onSecondary: secondary.estimatedBrightness.highEmphasisColor,
      surface: surface(brightness),
      onSurface: surface(brightness).highEmphasisOnColor,
      background: secondary,
      onBackground: secondary.highEmphasisOnColor,
      error: error(brightness),
      onError: error(brightness).highEmphasisOnColor,
    );
  }
}
