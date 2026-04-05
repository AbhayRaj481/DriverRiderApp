part of 'utils.dart';


class CustomSnackbar {
  CustomSnackbar._(); // Private constructor for singleton

  static const Duration _duration = Duration(seconds: 3);

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _showSnackbar(
      context,
      message,
      Colors.green,
      Icons.check_circle,
      duration: duration ?? _duration,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _showSnackbar(
      context,
      message,
      Colors.red,
      Icons.error,
      duration: duration ?? _duration,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _showSnackbar(
      context,
      message,
      Colors.blue,
      Icons.info,
      duration: duration ?? _duration,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _showSnackbar(
      context,
      message,
      Colors.orange,
      Icons.warning,
      duration: duration ?? _duration,
    );
  }

  static void _showSnackbar(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData icon, {
    required Duration duration,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Flexible(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: behavior,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
