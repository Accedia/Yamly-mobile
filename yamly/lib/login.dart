import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yamly/services/auth.dart';
import 'package:yamly/values/colors.dart';
import 'package:yamly/home.dart';
import 'package:yamly/values/widgets.dart';

class LoginPage extends StatefulWidget {
  final bool isLogin;

  const LoginPage({Key key, this.isLogin}) : super(key: key);

  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isLogin = widget.isLogin != null ? widget.isLogin : false;
    });

    if (!_isLogin) {
      Timer(Duration(milliseconds: 1500), advance);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(image: AssetImage('images/logo.png')),
        SizedBox(height: 30),
        _isLogin ? materialButton() : CustomWidgets.progressIndicator()
      ],
    )));
  }

  Widget materialButton() {
    return Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        elevation: 7,
        color: Style.PrimaryColor,
        clipBehavior: Clip.antiAlias,
        child: MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 15),
          minWidth: 200,
          textColor: Colors.white,
          child: Text("Sign In"),
          onPressed: () {
            authService.googleSignIn().then((user) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomePage()));
            });
          },
        ),
      );
  }

  advance() {
    authService.checkIfLogged().then((isLogged) {
      if (isLogged) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        setState(() {
          _isLogin = true;
        });
      }
    });
  }
}