import 'package:flutter/material.dart';

enum SnackBarType { standard, success, error, warning, info }

class ElegantSnackbar {
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final SnackBarType type;
  final Duration duration;

  const ElegantSnackbar({
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.type = SnackBarType.standard,
    this.duration = const Duration(seconds: 4),
  });

  /// Show the snackbar with animation
  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    SnackBarType type = SnackBarType.standard,
    Duration duration = const Duration(seconds: 4),
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_getIcon(type), color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        duration: duration,
        backgroundColor: _getBackgroundColor(type),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        margin: EdgeInsets.only(
          bottom: 16,
          top: 16,
          left: MediaQuery.sizeOf(context).width * 0.04,
          right: MediaQuery.sizeOf(context).width * 0.46,
        ),
        action:
            actionLabel != null
                ? SnackBarAction(
                  label: actionLabel,
                  onPressed: onActionPressed ?? () {},
                  textColor: Colors.white,
                )
                : null,
        animation: _createAnimation(context),
      ),
    );
  }

  /// Fade + Slide-in animation
  static Animation<double>? _createAnimation(BuildContext context) {
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: Navigator.of(context),
    );
    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.forward();
    return curvedAnimation;
  }

  static Color _getBackgroundColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Colors.green[600]!;
      case SnackBarType.error:
        return Colors.red[600]!;
      case SnackBarType.warning:
        return Colors.orange[700]!;
      case SnackBarType.info:
        return Colors.blue[600]!;
      default:
        return Colors.black87;
    }
  }

  static IconData _getIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_rounded;
      case SnackBarType.info:
        return Icons.info_outline;
      default:
        return Icons.info_outline;
    }
  }
}
