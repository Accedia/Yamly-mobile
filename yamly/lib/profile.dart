import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yamly/auth.dart';
import 'package:yamly/camera.dart';
import 'package:yamly/colors.dart';
import 'package:yamly/login.dart';
import 'data.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ml.dart';

class ProfilePage extends StatelessWidget {
  Future<String> getLabels(String path) async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFilePath(path);

    var labels = await mlKit.getImageLabels(visionImage);
    var text = "";

    for (ImageLabel label in labels) {
      text += "${label.text} ";
    }

    return Future(() => text);
  }

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
              color: Style.PrimaryColor,
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
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () async {
                if (await _checkAndRequestCameraPermissions()) {
                  _openCameraAndRetrieveImagePath(context);
                }
              },
              child: Text('Easter Egg'),
            )
          ]),
    )));
  }

  _openCameraAndRetrieveImagePath(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: firstCamera)));

    var text = await getLabels(result);

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<bool> _checkAndRequestCameraPermissions() async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.camera]);
      return permissions[PermissionGroup.camera] == PermissionStatus.granted;
    } else {
      return true;
    }
  }
}
