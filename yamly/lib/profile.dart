import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yamly/services/auth.dart';
import 'package:yamly/login.dart';
import 'package:yamly/models/data.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Image.network(data.user.photoUrl,
                  width: 100, height: 100, fit: BoxFit.cover),
            ),
            SizedBox(height: 20),
            Text(data.user.displayName, style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(data.user.email, style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0)),
              elevation: 7,
              color: Theme.of(context).primaryColor,
              clipBehavior: Clip.antiAlias,
              child: MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                minWidth: 200,
                textColor: Colors.white,
                child: Text("Log Out"),
                onPressed: () {
                  authService.signOut().then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(isLogin: true)));
                  });
                },
              ),
            )
          ]),
    )));
  }
}
