import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff336940),
      surfaceTint: Color(0xff336940),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb5f1bd),
      onPrimaryContainer: Color(0xff19512a),
      secondary: Color(0xff3b608f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd4e3ff),
      onSecondaryContainer: Color(0xff204876),
      tertiary: Color(0xff835415),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffddba),
      onTertiaryContainer: Color(0xff673d00),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffafaee),
      onSurface: Color(0xff1a1c15),
      onSurfaceVariant: Color(0xff45483d),
      outline: Color(0xff76786b),
      outlineVariant: Color(0xffc6c8b9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3129),
      inversePrimary: Color(0xff9ad4a2),
      primaryFixed: Color(0xffb5f1bd),
      onPrimaryFixed: Color(0xff00210b),
      primaryFixedDim: Color(0xff9ad4a2),
      onPrimaryFixedVariant: Color(0xff19512a),
      secondaryFixed: Color(0xffd4e3ff),
      onSecondaryFixed: Color(0xff001c39),
      secondaryFixedDim: Color(0xffa4c9fe),
      onSecondaryFixedVariant: Color(0xff204876),
      tertiaryFixed: Color(0xffffddba),
      onTertiaryFixed: Color(0xff2b1700),
      tertiaryFixedDim: Color(0xfff9ba72),
      onTertiaryFixedVariant: Color(0xff673d00),
      surfaceDim: Color(0xffdadbcf),
      surfaceBright: Color(0xfffafaee),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f4e8),
      surfaceContainer: Color(0xffeeefe3),
      surfaceContainerHigh: Color(0xffe9e9dd),
      surfaceContainerHighest: Color(0xffe3e3d8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff013f1b),
      surfaceTint: Color(0xff336940),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff42794e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff073764),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4a6f9f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff502f00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff946223),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffafaee),
      onSurface: Color(0xff10120b),
      onSurfaceVariant: Color(0xff34372d),
      outline: Color(0xff515448),
      outlineVariant: Color(0xff6b6e62),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3129),
      inversePrimary: Color(0xff9ad4a2),
      primaryFixed: Color(0xff42794e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff295f37),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4a6f9f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff305685),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff946223),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff784b0a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc7c7bc),
      surfaceBright: Color(0xfffafaee),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f4e8),
      surfaceContainer: Color(0xffe9e9dd),
      surfaceContainerHigh: Color(0xffddded2),
      surfaceContainerHighest: Color(0xffd2d2c7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003415),
      surfaceTint: Color(0xff336940),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1c532d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002d55),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff234a78),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff422600),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6a4000),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffafaee),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2a2d23),
      outlineVariant: Color(0xff474a3f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3129),
      inversePrimary: Color(0xff9ad4a2),
      primaryFixed: Color(0xff1c532d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003c19),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff234a78),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003360),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6a4000),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4b2b00),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb9baaf),
      surfaceBright: Color(0xfffafaee),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f1e6),
      surfaceContainer: Color(0xffe3e3d8),
      surfaceContainerHigh: Color(0xffd5d5ca),
      surfaceContainerHighest: Color(0xffc7c7bc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9ad4a2),
      surfaceTint: Color(0xff9ad4a2),
      onPrimary: Color(0xff003917),
      primaryContainer: Color(0xff19512a),
      onPrimaryContainer: Color(0xffb5f1bd),
      secondary: Color(0xffa4c9fe),
      onSecondary: Color(0xff00315d),
      secondaryContainer: Color(0xff204876),
      onSecondaryContainer: Color(0xffd4e3ff),
      tertiary: Color(0xfff9ba72),
      onTertiary: Color(0xff482900),
      tertiaryContainer: Color(0xff673d00),
      onTertiaryContainer: Color(0xffffddba),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff12140d),
      onSurface: Color(0xffe3e3d8),
      onSurfaceVariant: Color(0xffc6c8b9),
      outline: Color(0xff8f9284),
      outlineVariant: Color(0xff45483d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e3d8),
      inversePrimary: Color(0xff336940),
      primaryFixed: Color(0xffb5f1bd),
      onPrimaryFixed: Color(0xff00210b),
      primaryFixedDim: Color(0xff9ad4a2),
      onPrimaryFixedVariant: Color(0xff19512a),
      secondaryFixed: Color(0xffd4e3ff),
      onSecondaryFixed: Color(0xff001c39),
      secondaryFixedDim: Color(0xffa4c9fe),
      onSecondaryFixedVariant: Color(0xff204876),
      tertiaryFixed: Color(0xffffddba),
      onTertiaryFixed: Color(0xff2b1700),
      tertiaryFixedDim: Color(0xfff9ba72),
      onTertiaryFixedVariant: Color(0xff673d00),
      surfaceDim: Color(0xff12140d),
      surfaceBright: Color(0xff383a32),
      surfaceContainerLowest: Color(0xff0d0f09),
      surfaceContainerLow: Color(0xff1a1c15),
      surfaceContainer: Color(0xff1e2019),
      surfaceContainerHigh: Color(0xff292b23),
      surfaceContainerHighest: Color(0xff34362e),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffafebb7),
      surfaceTint: Color(0xff9ad4a2),
      onPrimary: Color(0xff002d11),
      primaryContainer: Color(0xff659d6f),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc9deff),
      onSecondary: Color(0xff00264a),
      secondaryContainer: Color(0xff6e93c5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd5a9),
      onTertiary: Color(0xff392000),
      tertiaryContainer: Color(0xffbd8543),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff12140d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdcdece),
      outline: Color(0xffb1b3a5),
      outlineVariant: Color(0xff8f9284),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e3d8),
      inversePrimary: Color(0xff1a522c),
      primaryFixed: Color(0xffb5f1bd),
      onPrimaryFixed: Color(0xff001505),
      primaryFixedDim: Color(0xff9ad4a2),
      onPrimaryFixedVariant: Color(0xff013f1b),
      secondaryFixed: Color(0xffd4e3ff),
      onSecondaryFixed: Color(0xff001127),
      secondaryFixedDim: Color(0xffa4c9fe),
      onSecondaryFixedVariant: Color(0xff073764),
      tertiaryFixed: Color(0xffffddba),
      onTertiaryFixed: Color(0xff1d0e00),
      tertiaryFixedDim: Color(0xfff9ba72),
      onTertiaryFixedVariant: Color(0xff502f00),
      surfaceDim: Color(0xff12140d),
      surfaceBright: Color(0xff43453d),
      surfaceContainerLowest: Color(0xff060804),
      surfaceContainerLow: Color(0xff1c1e17),
      surfaceContainer: Color(0xff272921),
      surfaceContainerHigh: Color(0xff31332c),
      surfaceContainerHighest: Color(0xff3d3e36),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc2ffc9),
      surfaceTint: Color(0xff9ad4a2),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff96d09e),
      onPrimaryContainer: Color(0xff000f03),
      secondary: Color(0xffe9f0ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffa0c5fa),
      onSecondaryContainer: Color(0xff000b1d),
      tertiary: Color(0xffffeddd),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfff5b66f),
      onTertiaryContainer: Color(0xff150800),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff12140d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeff1e1),
      outlineVariant: Color(0xffc2c4b5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e3d8),
      inversePrimary: Color(0xff1a522c),
      primaryFixed: Color(0xffb5f1bd),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff9ad4a2),
      onPrimaryFixedVariant: Color(0xff001505),
      secondaryFixed: Color(0xffd4e3ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffa4c9fe),
      onSecondaryFixedVariant: Color(0xff001127),
      tertiaryFixed: Color(0xffffddba),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfff9ba72),
      onTertiaryFixedVariant: Color(0xff1d0e00),
      surfaceDim: Color(0xff12140d),
      surfaceBright: Color(0xff4f5148),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1e2019),
      surfaceContainer: Color(0xff2f3129),
      surfaceContainerHigh: Color(0xff3a3c34),
      surfaceContainerHighest: Color(0xff46483f),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
