import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/utils/constants.dart';

abstract class MainSnackBar {
  static void showSuccessMessage(
    BuildContext context,
    String message, {
    Color? color,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      message,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  static void showMessage(
    BuildContext context,
    String message, {
    Color? color,
    Duration? duration,
  }) {
    _showSnackBar(context, message, icon: Icons.info, duration: duration);
  }

  static void showErrorMessage(
    BuildContext context,
    String message, {
    Color? color,
    Duration? duration,
  }) {
    _showSnackBar(context, message, icon: Icons.error, duration: duration);
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    required IconData icon,
    Duration? duration,
  }) {
    Flushbar(
      shouldIconPulse: true,
      onTap: (flushbar) => flushbar.dismiss(),
      margin: AppConstants.padding8,
      borderRadius: BorderRadius.circular(12),
      duration: duration ?? AppConstants.duration1500ms,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(icon),
      messageText: Text(message),
    ).show(context);
  }
}
