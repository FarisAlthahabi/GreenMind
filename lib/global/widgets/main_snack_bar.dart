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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    _showSnackBar(
      context,
      message,
      backgroundColor: color ?? colorScheme.primary,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    _showSnackBar(
      context,
      message,
      backgroundColor: color ?? colorScheme.secondaryContainer,
      icon: Icons.info,
      duration: duration,
    );
  }

  static void showErrorMessage(
    BuildContext context,
    String message, {
    Color? color,
    Duration? duration,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    _showSnackBar(
      context,
      message,
      backgroundColor: color ?? colorScheme.error,
      icon: Icons.error,
      duration: duration,
    );
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
    Duration? duration,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    Flushbar(
      shouldIconPulse: true,
      onTap: (flushbar) => flushbar.dismiss(),
      margin: AppConstants.padding8,
      borderRadius: BorderRadius.circular(12),
      backgroundColor: backgroundColor,
      duration: duration ?? AppConstants.duration1500ms,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(icon, color: colorScheme.onPrimary),
      messageText: Text(
        message,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),
    ).show(context);
  }
}