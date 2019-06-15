import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yamly/auth.dart';
import 'package:yamly/colors.dart';
import 'package:yamly/home.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(image: AssetImage('images/logo.png')),
        SizedBox(height: 40),
        Material(
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
                authService.updateUserData(user);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              });
            },
          ),
        ),
      ],
    )));
  }
}
