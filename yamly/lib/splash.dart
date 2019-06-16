import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yamly/colors.dart';
import 'auth.dart';
import 'home.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  State createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), advance);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('images/logo.png')),
            SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Style.PrimaryColor),
            )
          ],
        ),
      ),
    );
  }

  advance() {
    authService.checkIfLogged().then((isLogged) {
      var _pageToOpen = isLogged ? HomePage() : LoginPage();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => _pageToOpen));
    });
  }
}
