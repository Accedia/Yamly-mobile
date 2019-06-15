import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yamly/main.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: MaterialButton(
          child: Text("Login with Google"),
          color: Colors.white,
          textColor: Colors.black,
          onPressed: () { 
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page')));
          },
        ),
      )
    );
  }
}