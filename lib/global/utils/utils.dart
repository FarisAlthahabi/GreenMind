import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Utils {
  static Color? stringToColor(String color) {
    final hex = int.tryParse(color.substring(6, 16));
    if (hex == null) return null;
    return Color(hex);
  }

  static String convertDateFormat(String inputDate) {
    final regex = RegExp(r'^\d{4}/\d{2}/\d{2}$');
    if (regex.hasMatch(inputDate)) {
      return inputDate;
    }
    DateTime parsedDate = DateTime.parse(inputDate);
    String formattedDate =
        "${parsedDate.year}/${twoDigits(parsedDate.month)}/${twoDigits(parsedDate.day)}";
    return formattedDate;
  }

  static String twoDigits(int n) => n.toString().padLeft(2, '0');

  static String? convertToIsoFormat(DateTime? date) {
    if (date == null) {
      return null;
    }
    return DateFormat('yyyy-MM-dd', 'en').format(date);
  }

  static double colorToHue(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.hue;
  }

  static String convertToIsoFormatFromString(String inputDate) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (regex.hasMatch(inputDate)) {
      return inputDate;
    }
    DateTime parsedDate = DateTime.parse(inputDate);
    return DateFormat('yyyy-MM-dd', 'en').format(parsedDate);
  }

  static String capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  static double calcSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return (size / 390) * screenWidth / 1.2;
    }
    return (size / 390) * screenWidth;
  }

  static String? validateInput(
    String? val,
    InputTextType type, {
    String emptyMessage = 'required',
  }) {
    if (val == null || val.trim().isEmpty) {
      return emptyMessage.tr();
    }
    if (type == InputTextType.email) {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(val)) {
        return 'email_invalid'.tr();
      }
    } else if (type == InputTextType.phone) {
      if (val.length != 10) {
        return 'phone_number_10_digits'.tr();
      } else if (!val.startsWith('09')) {
        return 'phone_number_start_09'.tr();
      }
    } else if (type == InputTextType.password) {
      if (val.length < 8) {
        return 'password_8_chars'.tr();
      }
    }
    return null;
  }
}

enum InputTextType { email, phone, password, none }

TextTheme createTextTheme(
  TextTheme baseTextTheme,
  String bodyFontFamily,
  String displayFontFamily,
) {
  final bodyTextTheme = GoogleFonts.getTextTheme(bodyFontFamily, baseTextTheme);
  final displayTextTheme = GoogleFonts.getTextTheme(
    displayFontFamily,
    baseTextTheme,
  );

  return displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
}
