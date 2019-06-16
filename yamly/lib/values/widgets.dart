import 'package:flutter/material.dart';
import 'colors.dart';

class CustomWidgets{
  static Widget progressIndicator() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Style.PrimaryColor));
  }
}