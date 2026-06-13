import 'package:flutter/material.dart';
import 'package:get/get.dart';

final class AppSnackBar {
  static void networkError(String message) => _show('Connection Error', message, isError: true);
  static void tokenExpired() => _show('Session Expired', 'Please log in again.');
  static void serverError(int? code) => _show('Server Error', 'Something went wrong (${code ?? '?'}). Please try again later.', isError: true);

  static void _show(String title, String message, {bool isError = false}) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(12),
        backgroundColor: isError ? Colors.red.shade700 : Colors.orange.shade700,
        colorText: Colors.white,
        icon: Icon(isError ? Icons.wifi_off_rounded : Icons.info_outline_rounded, color: Colors.white),
      );
    }
  }
}
