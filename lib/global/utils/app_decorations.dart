import 'package:flutter/material.dart';

abstract class AppDecorations {
  static const fisrtShadow = [BoxShadow(blurRadius: 1, offset: Offset(0, 1))];

  static const secondShadow = [BoxShadow(blurRadius: 2, offset: Offset(0, 2))];

  static const thirdShadow = [BoxShadow(blurRadius: 4, offset: Offset(0, 4))];
}
