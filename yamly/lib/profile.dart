import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yamly/services/auth.dart';
import 'package:yamly/camera.dart';
import 'package:yamly/login.dart';
import 'package:yamly/models/data.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ml.dart';

class ProfilePage extends StatelessWidget {
  Future<bool> isItAHotDog(String path) async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFilePath(path);

    var labels = await mlKit.getImageLabels(visionImage);
    bool isIt = false;

    for (ImageLabel label in labels) {
      var lowerCased = label.text.toLowerCase();

      if (lowerCased == "hot dog bun" ||
          lowerCased == "hog dog" ||
          lowerCased == "hotdog") {
        isIt = true;
        break;
      }
    }

    return Future(() => isIt);
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

    var isIt = await isItAHotDog(result);

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
          SnackBar(content: Text(isIt ? "HOTDOG!" : "NOT HOTDOG :(")));
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
