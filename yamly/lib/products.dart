import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yamly/models/data.dart';
import 'package:yamly/models/product_model.dart';
import 'dart:core';

import 'package:yamly/product_details.dart';
import 'package:yamly/services/api_service.dart';
import 'package:yamly/services/auth.dart';
import 'package:yamly/values/widgets.dart';
import 'package:flutter_image/network.dart';

import 'camera.dart';
import 'ml.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  List<Widget> _cards;
  double myOpacity = 0.9;
  final loadedItems = 15;

  @override
  void initState() {
    super.initState();
    _reloadCards();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await APIService().addProduct();
      if (mounted) {
        setState(() {
          _reloadCards();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _cards.length > 0
            ? Stack(alignment: Alignment.center, children: _cards)
            : CustomWidgets.progressIndicator(),
      ),
    ));
  }

  void _reloadCards() {
    _cards = List<Widget>();

    for (int x = 0; x < min(data.products.length, loadedItems); x++) {
      _cards.add(AnimatedItemCart(
          product: data.products[x], x: x, callback: _removeCard));
    }
    setState(() {});
  }

  void _removeCard(int index) {
    setState(() {
      data.products.removeAt(index);
      _cards.removeAt(index);
      if (_cards.length < 1) {
        _cards = new List<Widget>();
        Timer(Duration(milliseconds: 200), () {
          _reloadCards();
        });
      }
    });
    if (data.products.length < loadedItems) {
      APIService().addProduct();
    }
  }
}

typedef void IndexCallback(int index);

class AnimatedItemCart extends StatefulWidget {
  AnimatedItemCart({
    Key key,
    @required this.x,
    @required this.product,
    this.callback,
    this.color,
  }) : super(key: key);

  final int x;
  final IndexCallback callback;
  final Color color;
  final ProductModel product;

  @override
  _AnimatedItemCartState createState() => _AnimatedItemCartState();
}

class _AnimatedItemCartState extends State<AnimatedItemCart>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  bool _isSpecialVisible = false;
  bool _isSpecialGone = true;
  String _hotDogText = '';

  bool notNull(Object o) => o != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

  void initAnimation(bool isLeft) {
    int position = isLeft ? 1 : -1;
    _animation = Tween(begin: 0.0, end: position * 600.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          widget.callback(widget.x);
        }
      });
  }

  void likeAction(bool hasAnimation) {
    authService.addProductLike(widget.product.id);
    if (hasAnimation) {
      setState(() {
        initAnimation(false);
        _controller.forward();
      });
    }
  }

  void dislikeAction(bool hasAnimation) {
    authService.addProductDislike(widget.product.id);
    if (hasAnimation) {
      setState(() {
        initAnimation(true);
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MoveTransition(
      animation: _animation,
      child: Align(
          alignment: Alignment.center,
          child: Dismissible(
              key: Key(Random().toString()),
              crossAxisEndOffset: -0.1,
              onResize: () {},
              onDismissed: (direction) {
                widget.callback(widget.x);
                if (direction == DismissDirection.endToStart) {
                  dislikeAction(false);
                } else {
                  likeAction(false);
                }
              },
              child: Container(
                decoration: new BoxDecoration(boxShadow: [
                  new BoxShadow(
                    offset: Offset(0, 5),
                    color: Colors.black12,
                    blurRadius: 5,
                  ),
                ]),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                        children: <Widget>[
                      Center(child: Image.asset('images/logo.png')),
                      Hero(
                        tag: "Food" + widget.x.toString(),
                        child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset.topCenter,
                                  image: NetworkImageWithRetry(
                                      widget.product.imageUrl),
                                ))),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: VoteButton(
                              color: Colors.black45,
                              icon: Icon(
                                Icons.thumb_down,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                dislikeAction(true);
                              })),
                      Align(
                          alignment: Alignment.centerRight,
                          child: VoteButton(
                              color: Colors.black45,
                              icon: Icon(Icons.thumb_up,
                                  color: Colors.greenAccent),
                              onPressed: () {
                                likeAction(true);
                              })),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Hero(
                              tag: "Text" + "Food" + widget.x.toString(),
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                    decoration: new BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.7),
                                        borderRadius: new BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    child: ListTile(
                                        onTap: () async {
                                          if (widget.product.id != -1) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductInfoPage(
                                                            tag: "Food" +
                                                                widget.x
                                                                    .toString(),
                                                            product: widget
                                                                .product)));
                                          } else {
                                            if (await _checkAndRequestCameraPermissions()) {
                                              _openCameraAndRetrieveImagePath(
                                                  context);
                                            }
                                          }
                                        },
                                        title: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(widget.product.name,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        trailing: Icon(
                                            (widget.product.id != -1)
                                                ? Icons.keyboard_arrow_up
                                                : Icons.visibility,
                                            size: 30,
                                            color: Colors.white))),
                              ))),
                      (!_isSpecialGone)
                          ? AnimatedOpacity(
                              opacity: _isSpecialVisible ? 1 : 0,
                              duration: Duration(milliseconds: 500),
                              child: Align(
                                alignment: Alignment.center,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.orangeAccent,
                                        boxShadow: [
                                          new BoxShadow(
                                            offset: Offset(0, 10),
                                            color: Colors.black26,
                                            blurRadius: 10.0,
                                          ),
                                        ]),
                                    width: 350,
                                    height: 200,
                                    child: Center(
                                      child: Text(_hotDogText,
                                          style: TextStyle(
                                              fontSize: 50,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : null
                    ].where(notNull).toList()),
                  ),
                ),
              ))),
    );
  }

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

  _openCameraAndRetrieveImagePath(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: firstCamera)));

    var isIt = await isItAHotDog(result);

    setState(() {
      _hotDogText = isIt ? "Hotdog" : "Not hotdog";
      _isSpecialGone = false;
      _isSpecialVisible = true;

      Timer(Duration(milliseconds: 3000), () {
        setState(() {
          _isSpecialVisible = false;

          Timer(Duration(milliseconds: 1000), () {
            setState(() {
              _isSpecialGone = true;
            });
          });
        });
      });
    });
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

class VoteButton extends StatelessWidget {
  const VoteButton({Key key, this.onPressed, this.icon, this.color})
      : super(key: key);
  final VoidCallback onPressed;
  final Icon icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ClipOval(
          child: Material(
              color: Colors.transparent,
              child: Container(
                color: color,
                child: IconButton(
                    padding: EdgeInsets.all(20),
                    icon: icon,
                    onPressed: onPressed),
              ))),
    );
  }
}

class MoveTransition extends StatelessWidget {
  MoveTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) => Transform.translate(
      offset: Offset(-(animation != null ? animation.value : 0.0),
          -(animation != null ? animation.value.abs() / 6 : 0.0)),
      child: child);
}
