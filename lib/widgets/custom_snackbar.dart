import 'package:flutter/material.dart';

class SnackShow {
  static showSnackbar(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(message)));
  }
}
