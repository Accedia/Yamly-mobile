import 'package:flutter/material.dart';
import 'package:yamly/colors.dart';
import 'package:yamly/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: Style.PrimaryColor, fontFamily: 'GothamRounded'),
        home: LoginPage());
  }
}
