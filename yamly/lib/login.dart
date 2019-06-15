import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yamly/auth.dart';

import 'home.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: MaterialButton(
        child: Text("Login with Google"),
        color: Colors.white,
        textColor: Colors.black,
        onPressed: () {
          authService.googleSignIn().then((user) {
            authService.updateUserData(user);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          });
        },
      ),
    ));
  }
}
