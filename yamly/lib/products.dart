import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yamly/models/data.dart';
import 'package:yamly/models/product_model.dart';
import 'dart:core';

import 'package:yamly/product_details.dart';
import 'package:yamly/services/api_service.dart';
import 'package:yamly/values/widgets.dart';
import 'package:flutter_image/network.dart';

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
      if (mounted){
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
            padding: const EdgeInsets.all(25),
            child: 
              _cards.length > 0 ?
                Stack(alignment: Alignment.center, children: _cards) :
                CustomWidgets.progressIndicator(),
          ),
    ));
  }

  void _reloadCards() {
    _cards = List<Widget>();

    for (int x = 0; x < min(data.products.length, loadedItems); x++) {
      _cards.add(
        AnimatedItemCart(product: data.products[x], x: x, callback: _removeCard)
      );
    }
    setState(() {});
  }

  void _removeCard(int index) {
    setState(() {
      data.products.removeAt(index);
      _cards.removeAt(index);
      if (_cards.length < 1)
      {
        _cards = new List<Widget>();
        Timer(Duration(milliseconds: 200), () {_reloadCards();});
      }
    });
    if (data.products.length < loadedItems)
    {
      APIService().addProduct();
    }
  }
}

typedef void IndexCallback(int index);

class AnimatedItemCart extends StatefulWidget{
  AnimatedItemCart({
    Key key,
    @required this.x, @required this.product, this.callback, this.color,
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
  }

  void initAnimation(bool isLeft) {
    int position = isLeft ? 1: -1;
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
            },
            child: Container(
              decoration: new BoxDecoration(boxShadow: [
                new BoxShadow(
                  offset: Offset(0, 10),
                  color: Colors.black26,
                  blurRadius: 10.0,
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
                      Center(
                        child: Image.asset('images/logo.png')
                      ),
                      Hero(
                        tag: "Food" + widget.x.toString(),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image(
                            image: NetworkImageWithRetry(widget.product.imageUrl),
                          )
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: VoteButton(
                          icon: Icon(
                            Icons.thumb_down,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              initAnimation(true);
                              _controller.forward();
                            });
                        })
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: VoteButton(
                          icon: Icon(Icons.thumb_up, 
                            color: Colors.greenAccent),
                          onPressed: (){
                            setState(() {
                              initAnimation(false);
                              _controller.forward();
                            });
                          }
                        )
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Hero(
                          tag: "Text" + "Food" + widget.x.toString(),
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              decoration: new BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      topRight: const Radius.circular(10.0))),
                              child: ListTile(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => 
                                    ProductInfoPage(tag: "Food" + widget.x.toString(), product: widget.product)));
                                },
                                title: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child:Text(widget.product.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))
                                  ),
                                trailing: Icon(Icons.arrow_drop_up, color: Colors.white))),
                          )
                      ))
                    ]),
                  ),
                ),
              )
            )
          ),
    );
  }
}

class VoteButton extends StatelessWidget {
  const VoteButton({
    Key key, 
    this.onPressed, this.icon,
  }) : super(key: key);
  final VoidCallback onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.black38,
            child: IconButton(
              padding: EdgeInsets.all(20),
              icon: icon,
              onPressed: onPressed
            ),
          )
        )),
    );
  }
}

class MoveTransition extends StatelessWidget {
  MoveTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) => 
      Transform.translate(
        offset: Offset(
          - (animation != null ? animation.value : 0.0), 
          - (animation != null ? animation.value.abs() / 6 : 0.0)),
        child: child
      );
}