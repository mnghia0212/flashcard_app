import 'package:another_flushbar/flushbar.dart';
import 'package:flashcard_app/utils/extensions.dart';
import 'package:flutter/material.dart';

enum AlertType { success, warning, error, info }

class AppAlerts {
  static showFlushBar(BuildContext context, String message, AlertType type) {
    Color backgroundColor;
    IconData icon;
    String alertTitle;
    final colors = context.colorScheme;

    switch (type) {
      case AlertType.success:
        backgroundColor = Colors.green.shade300;
        icon = Icons.check_circle;
        alertTitle = "Success";
        break;

      case AlertType.warning:
        backgroundColor = Colors.yellow.shade300;
        icon = Icons.warning;
        alertTitle = "Warning";
        break;

      case AlertType.error:
        backgroundColor = Colors.red.shade300;
        icon = Icons.error;
        alertTitle = "Error";
        break;

      default:
        backgroundColor = Colors.orange.shade300;
        icon = Icons.info;
        alertTitle = "Info";
    }

    Flushbar(
      titleText: Text(alertTitle),
      titleColor: Colors.black,
      titleSize: 20,
      message: message,
      messageColor: Colors.black,
      messageSize: 17,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      duration: const Duration(milliseconds: 1300),
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      backgroundColor: backgroundColor,
      icon: Icon(
        icon,
        color: Colors.black,
      ),
      padding: const EdgeInsets.all(20),
      boxShadows: const [
        BoxShadow(color: Colors.grey, offset: Offset(0.0, 2.0), blurRadius: 3.0)
      ],
    ).show(context);
  }
}
