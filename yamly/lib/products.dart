import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yamly/models/foodModel.dart';
import 'dart:core';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  List<FoodModel> _foods;
  List<Widget> _cards;
  double myOpacity = 0.9;

  @override
  void initState() {
    super.initState();
    _foods = List<FoodModel>();
    for (int x = 0; x < 30; x++) {
      _foods.add(FoodModel());
    }
    _cards = _getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(alignment: Alignment.center, children: _cards),
          ),
        ));
  }

  List<Widget> _getCards() {
    var cards = List<Widget>();

    for (int x = 0; x < _foods.length; x++) {
      cards.add(
        AnimatedItemCart(x: x, callback: _removeCard,
          color: Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                  .withOpacity(1.0))
      );
    }

    return cards;
  }

  void _removeCard(int index) {
    setState(() {
      _foods.removeAt(index);
      _cards.removeAt(index);
    });
  }
}

typedef void IndexCallback(int index);

class AnimatedItemCart extends StatefulWidget{
  AnimatedItemCart({
    Key key,
    @required this.x, this.callback, this.color,
  }) : super(key: key);

  final int x;
  final IndexCallback callback;
  final Color color;

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
    //initAnimation();
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
            child: Card(
              elevation: 12,
              color: widget.color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.arrow_left,
                            color: Colors.white,
                          ),
                          iconSize: 50,
                          onPressed: () {
                            setState(() {
                              initAnimation(true);
                              _controller.forward();
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.arrow_right, color: Colors.white),
                          iconSize: 50,
                          onPressed: () {
                            setState(() {
                              initAnimation(false);
                              _controller.forward();
                            });
                          })
                    ]),
              ),
            )
          ),
        )
    );
  }
}

class MoveTransition extends StatelessWidget {
  MoveTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;
  final double offset = 20.0;

  Widget build(BuildContext context) => 
      Positioned(
        right: offset + (animation != null ? animation.value : 0),
        left: offset - (animation != null ? animation.value : 0),
        top: offset - (animation != null ? animation.value.abs() / 3 : 0),
        bottom: offset + (animation != null ? animation.value.abs() / 3 : 0),
        child: child,
      );
}
