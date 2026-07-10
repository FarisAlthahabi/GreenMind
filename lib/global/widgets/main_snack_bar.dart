import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';

abstract class MainSnackBar {
  static void showSuccessMessage(
    BuildContext context,
    String message, {
    Color? bgColor,
    Color? messageColor,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      bgColor: bgColor ?? context.cs.primaryContainer,
      messageColor: messageColor ?? context.cs.primary,
      message,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  static void showMessage(
    BuildContext context,
    String message, {
    Color? bgColor,
    Color? messageColor,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      message,
      bgColor: bgColor,
      messageColor: messageColor,
      icon: Icons.info,
      duration: duration,
    );
  }

  static void showErrorMessage(
    BuildContext context,
    String message, {
    Color? bgColor,
    Color? messageColor,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      message,
      bgColor: bgColor ?? context.cs.errorContainer,
      messageColor: messageColor ?? context.cs.onErrorContainer,
      icon: Icons.error,
      duration: duration,
    );
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    required IconData icon,
    Color? bgColor,
    Color? messageColor,
    Duration? duration,
  }) {
    Flushbar(
      shouldIconPulse: true,
      backgroundColor: bgColor ?? Colors.grey,
      onTap: (flushbar) => flushbar.dismiss(),
      margin: AppConstants.padding8,
      borderRadius: AppConstants.borderRadius12,
      duration: duration ?? AppConstants.duration1500ms,
      flushbarPosition: .TOP,
      icon: Icon(icon, color: messageColor ?? Colors.black),
      messageText: Text(
        message,
        style: context.tt.titleMedium?.copyWith(
          color: messageColor ?? Colors.black,
        ),
      ),
    ).show(context);
  }
}
