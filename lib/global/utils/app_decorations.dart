import 'package:flutter/material.dart';

abstract class AppDecorations {
  static List<BoxShadow> fisrtShadow = [
    BoxShadow(blurRadius: 1, offset: const Offset(0, 1)),
  ];

  static List<BoxShadow> secondShadow = [
    BoxShadow(blurRadius: 2, offset: const Offset(0, 2)),
  ];

  static List<BoxShadow> thirdShadow = [
    BoxShadow(blurRadius: 4, offset: const Offset(0, 4)),
  ];
}
