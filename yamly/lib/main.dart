import 'package:flutter/material.dart';
import 'package:yamly/values/colors.dart';
import 'package:yamly/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yamly',
        theme: ThemeData(
            primaryColor: Style.PrimaryColor, fontFamily: 'GothamRounded'),
        home: LoginPage());
  }
}
