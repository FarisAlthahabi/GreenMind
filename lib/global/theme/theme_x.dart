import 'package:flutter/material.dart';

extension ThemeX on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;
  TextTheme get tt => Theme.of(this).textTheme;
  ThemeData get t => Theme.of(this);
}
