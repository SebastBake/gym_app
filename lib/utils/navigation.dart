import 'package:flutter/material.dart';

class NavUtil {
  static void push(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  static void back(BuildContext context) {
    Navigator.of(context).pop();
  }
}
