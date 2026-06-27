import 'package:flutter/material.dart';
import 'package:green_mind/global/utils/app_colors.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: "Cairo",
  primaryColor: AppColors.darkPrimary,
  brightness: Brightness.dark,
  
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.darkPrimaryContainer,
    onPrimaryContainer: AppColors.darkOnPrimaryContainer,
    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.darkOnSecondary,
    secondaryContainer: AppColors.darkSecondaryContainer,
    onSecondaryContainer: AppColors.darkOnSecondaryContainer,
    tertiary: AppColors.darkTertiary,
    onTertiary: AppColors.darkOnTertiary,
    tertiaryContainer: AppColors.darkTertiaryContainer,
    onTertiaryContainer: AppColors.darkOnTertiaryContainer,
    error: AppColors.darkError,
    onError: AppColors.darkOnError,
    errorContainer: AppColors.darkErrorContainer,
    onErrorContainer: AppColors.darkOnErrorContainer,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    surfaceContainerHighest: AppColors.darkSurfaceVariant,
    onSurfaceVariant: AppColors.darkOnSurfaceVariant,
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,
    shadow: AppColors.shadow,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.darkInverseSurface,
    onInverseSurface: AppColors.darkOnInverseSurface,
    inversePrimary: AppColors.darkInversePrimary,
    surfaceTint: AppColors.darkSurfaceTint,
  ),
  
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.darkOnSurface,
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
  
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    selectedItemColor: AppColors.darkPrimary,
    unselectedItemColor: AppColors.darkOnSurfaceVariant,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
  
  cardTheme: CardThemeData(
    color: AppColors.darkSurface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(
        color: AppColors.darkOutlineVariant,
        width: 1,
      ),
    ),
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.darkOnPrimary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.darkPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.darkPrimary,
      side: const BorderSide(color: AppColors.darkOutline),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  
  inputDecorationTheme: InputDecorationTheme(
    fillColor: AppColors.darkSurface,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.darkOutlineVariant),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.darkOutlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.darkError),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.darkError, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    surfaceTintColor: Colors.transparent,
    indicatorColor: AppColors.darkPrimaryContainer,
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  ),
  
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: AppColors.darkSurface,
    indicatorColor: AppColors.darkPrimaryContainer,
    selectedIconTheme: const IconThemeData(color: AppColors.darkPrimary),
    unselectedIconTheme: const IconThemeData(color: AppColors.darkOnSurfaceVariant),
  ),
  
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.darkPrimary,
    foregroundColor: AppColors.darkOnPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.darkSurface,
    disabledColor: AppColors.darkSurfaceVariant,
    selectedColor: AppColors.darkPrimaryContainer,
    secondarySelectedColor: AppColors.darkPrimaryContainer,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    labelStyle: TextStyle(
      color: AppColors.darkOnSurface,
      fontSize: 14,
    ),
    secondaryLabelStyle: TextStyle(
      color: AppColors.darkPrimary,
      fontSize: 14,
    ),
    side: const BorderSide(color: AppColors.darkOutlineVariant),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.darkSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 0,
  ),
  
  bottomSheetTheme: const BottomSheetThemeData(
    showDragHandle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),
  
  dividerTheme: const DividerThemeData(
    color: AppColors.darkOutlineVariant,
    thickness: 1,
  ),
  
  iconTheme: const IconThemeData(
    color: AppColors.darkOnSurfaceVariant,
    size: 24,
  ),
  
  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  
  scaffoldBackgroundColor: AppColors.darkBackground,
);