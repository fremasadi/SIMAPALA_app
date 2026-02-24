import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SafeMessage {
  // Show message dengan delay untuk memastikan context tersedia
  static void show(String title, String message, Color backgroundColor) {
    // Gunakan Future.microtask untuk ensure overlay ready
    Future.microtask(() {
      final context = Get.context;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      backgroundColor == Colors.green
                          ? Icons.check_circle
                          : backgroundColor == Colors.red
                          ? Icons.error_outline
                          : Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: backgroundColor,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  // Simple message without title
  static void showSimple(String message, Color backgroundColor) {
    Future.microtask(() {
      final context = Get.context;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
            backgroundColor: backgroundColor,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  // Success message
  static void success(String title, String message) {
    show(title, message, Colors.green);
  }

  // Error message
  static void error(String title, String message) {
    show(title, message, Colors.red);
  }

  // Warning message
  static void warning(String title, String message) {
    show(title, message, Colors.orange);
  }
}
