import 'package:flutter/material.dart';
import 'package:monirth_memories/core/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

void snackBar(BuildContext context, String msg, {bool showInTop = false}) {
  final service = locator<SnackbarService>();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  if (service.isSnackbarOpen) {
    service.closeSnackbar();
  }

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.light,
    config: SnackbarConfig(
      backgroundColor: Colors.white,
      textColor: Colors.black,
      borderRadius: 12,
      snackPosition: showInTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      titleColor: Colors.black87,
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.dark,
    config: SnackbarConfig(
      backgroundColor: Colors.grey[850]!,
      textColor: Colors.white,
      borderRadius: 12,
      snackPosition: showInTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      titleColor: Colors.white70,
    ),
  );

  service.showCustomSnackBar(
    variant: isDark ? SnackbarType.dark : SnackbarType.light,
    message: msg,
    duration: const Duration(seconds: 1),
  );
}

enum SnackbarType { light, dark }
