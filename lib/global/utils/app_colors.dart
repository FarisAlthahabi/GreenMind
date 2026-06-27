import 'package:flutter/material.dart';

abstract class AppColors {
  static const mainColor = Color(0xFFA67F37);
  static const mainColorSecondary = Color(0xFF1D1D1D);
  static const whiteShade = Color(0xFFD9D9D9);
  static const greyShade = Color(0xFF505050);
  static const greyShade3 = Color(0xFF9A9191);
  static const black = Colors.black;
  static const blackShade2 = Color(0xFF0A090C);
  static const white = Colors.white;
  static const grey = Colors.grey;
  static const orange = Colors.orange;
  static const red = Colors.red;
  static const blue = Colors.blue;
  static const green = Colors.green;
  static const yellow = Colors.yellow;

  static List<BoxShadow> fisrtShadow = [
    BoxShadow(
      color: black.withValues(alpha: 0.3),
      blurRadius: 1,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> secondShadow = [
    BoxShadow(
      color: black.withValues(alpha: 0.3),
      blurRadius: 2,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> thirdShadow = [
    BoxShadow(
      color: black.withValues(alpha: 0.3),
      blurRadius: 4,
      offset: const Offset(0, 4),
    ),
  ];
}
