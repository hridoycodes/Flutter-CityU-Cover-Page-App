import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum MessageType {
  success,
  error,
  info,
}

class MessageUtils {
  static void showSnackBar(
      BuildContext context,
      String message, {
        MessageType type = MessageType.info,
      }) {
    final color = _getBackgroundColor(type);

    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showToast(
      String message, {
        MessageType type = MessageType.info,
      }) {
    final backgroundColor = _getBackgroundColor(type);

    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Color _getBackgroundColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return Colors.red;
      case MessageType.info:
      default:
        return Colors.blue;
    }
  }
}
