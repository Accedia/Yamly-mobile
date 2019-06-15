import 'package:flutter/material.dart';
import 'package:yamly/auth.dart';
import 'package:yamly/home.dart';
import 'package:yamly/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'GothamRounded'
      ),
      home: authService.user != null ? HomePage() : LoginPage()
    );
  }
}