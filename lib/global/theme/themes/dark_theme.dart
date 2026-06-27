import 'package:flutter/material.dart';
import 'package:green_mind/global/utils/app_colors.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: "JF Flat",
  primaryColor: AppColors.mainColor,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.mainColor,
    onPrimary: AppColors.mainColorSecondary,
    secondary: AppColors.mainColorSecondary,
    onSecondary: Colors.black54,
    error: AppColors.red,
    onError: AppColors.mainColor,
    surface: AppColors.white,
    onSurface: AppColors.mainColorSecondary,
    onTertiary: Colors.black,
    onSecondaryFixed: AppColors.grey,
    onPrimaryFixed: AppColors.blue,
    onTertiaryFixed: AppColors.black,
    onTertiaryContainer: AppColors.white,
  ),
  appBarTheme: const AppBarTheme(backgroundColor: AppColors.white),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.mainColor,
    selectedItemColor: AppColors.white,
    unselectedItemColor: AppColors.greyShade3,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: false,
    showUnselectedLabels: false,
  ),
);
