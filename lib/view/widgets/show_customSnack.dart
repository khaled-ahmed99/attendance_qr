import 'package:flutter/material.dart';

void showCustomSnack(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: 3),
      backgroundColor: color,
    ),
  );
}
