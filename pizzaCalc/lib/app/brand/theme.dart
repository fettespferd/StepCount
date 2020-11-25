import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static ThemeData primary(Brightness brightness) {
    return _themeFrom(brightness, AppColors.primaryScheme(brightness)).copyWith(
      textSelectionHandleColor: AppColors.secondary(brightness),
      cursorColor: AppColors.secondary(brightness),
    );
  }

  static ThemeData secondary(Brightness brightness) {
    return _themeFrom(brightness, AppColors.secondaryScheme(brightness))
        .copyWith(textSelectionHandleColor: AppColors.primary(brightness));
  }

  static ThemeData _themeFrom(Brightness brightness, ColorScheme scheme) {
    final textTheme = AppTheme.textTheme.apply(
      displayColor: scheme.onBackground,
      bodyColor: scheme.onBackground,
    );
    final theme = ThemeData(
      colorScheme: scheme,
      primarySwatch: scheme.primary as MaterialColor,
      toggleableActiveColor: scheme.secondary,
      accentColor: scheme.secondary,
      canvasColor: scheme.surface,
      scaffoldBackgroundColor: scheme.background,
      cardColor: scheme.surface,
      disabledColor: scheme.surface.disabledOnColor,
      backgroundColor: scheme.background,
      errorColor: scheme.error,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        brightness: scheme.background.estimatedBrightness,
        color: scheme.background,
        textTheme: textTheme,
        iconTheme: IconThemeData(color: scheme.background.contrastColor),
      ),
    );
    return theme.copyWith(
      applyElevationOverlayColor: true,
      textSelectionColor: AppColors.secondary(brightness).withAlpha(100),
      iconTheme: theme.iconTheme.copyWith(color: scheme.onBackground),
      snackBarTheme:
          theme.snackBarTheme.copyWith(behavior: SnackBarBehavior.floating),
    );
  }

  static const textTheme = TextTheme(
    headline1: TextStyle(
      fontFamily: 'Lato',
      fontSize: 112,
      fontWeight: FontWeight.w300,
      letterSpacing: 0,
    ),
    headline2: TextStyle(
      fontFamily: 'Lato',
      fontSize: 56,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
    ),
    headline3: TextStyle(
      fontFamily: 'Lato',
      fontSize: 45,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
    ),
    headline4: TextStyle(
      fontFamily: 'Lato',
      fontSize: 34,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
    ),
    headline5: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
    ),
    headline6:
        TextStyle(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0),
    subtitle1: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
    ),
    subtitle2:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0),
    bodyText1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.4,
    ),
    bodyText2: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
      height: 1.4,
    ),
    button:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0),
    caption: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      height: 1.4,
      letterSpacing: 0,
    ),
    overline: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
    ),
  );
}
