import 'package:flutter/material.dart';
import '../theme/vendor_colors.dart';

/// Global key to access the ScaffoldMessenger without BuildContext
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class SnackbarService {
  /// Shows a success snackbar
  static void showSuccess(String message) {
    _showSnackbar(message, VendorColors.success, Icons.check_circle_outline);
  }

  /// Shows an error snackbar
  static void showError(String message) {
    _showSnackbar(message, VendorColors.error, Icons.error_outline);
  }

  /// Shows an informational snackbar
  static void showInfo(String message) {
    _showSnackbar(message, VendorColors.primary, Icons.info_outline);
  }

  static void _showSnackbar(String message, Color backgroundColor, IconData icon) {
    // Ensure we run this on the main thread
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldMessengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: backgroundColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(16),
            elevation: 4,
            duration: const Duration(seconds: 4),
          ),
        );
    });
  }
}
