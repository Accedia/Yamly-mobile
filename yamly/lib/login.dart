import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yamly/auth.dart';
import 'package:yamly/colors.dart';
import 'package:yamly/home.dart';

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
      Timer(Duration(seconds: 2), advance);
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
        progressIndicator(),
        materialButton()
      ],
    )));
  }

  Widget progressIndicator() {
    return Visibility(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Style.PrimaryColor)),
      visible: !_isLogin,
    );
  }

  Widget materialButton() {
    return Visibility(
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
          elevation: 7,
          color: Style.PrimaryColor,
          clipBehavior: Clip.antiAlias,
          child: MaterialButton(
            minWidth: 200,
            textColor: Colors.white,
            child: Text("Login with Google"),
            onPressed: () {
              authService.googleSignIn().then((user) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              });
            },
          ),
        ),
        visible: _isLogin);
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
