import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle body(BuildContext context, {bool bold = false}) {
    final width = MediaQuery.of(context).size.width;
    final double size = width < 380
        ? 13.5
        : width > 600
        ? 17
        : 15;

    return TextStyle(
      fontSize: size,
      fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
    );
  }

  static TextStyle title(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double size = width < 380
        ? 16
        : width > 600
        ? 20
        : 18;

    return TextStyle(fontSize: size, fontWeight: FontWeight.bold);
  }

  static TextStyle caption(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double size = width < 380 ? 11.5 : 13;
    return TextStyle(fontSize: size, color: Colors.grey.shade600);
  }
}
