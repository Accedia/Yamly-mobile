import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yamly/login.dart';
import 'package:yamly/match_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Widget> cardList;
  AnimationController _buttonController;
  var matrix = Matrix4.identity();

  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;

  double skew = 0;
  var rotation = 0;
  var tag = "tag";

  @override
  void initState() {
    super.initState();
    cardList = _getMatchCard();
    cardList.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_left,
                color: Colors.white,
              ),
              iconSize: 50,
              onPressed: () {
                _swipeAnimation();
              }),
          IconButton(
            icon: Icon(Icons.arrow_right, color: Colors.white),
            iconSize: 50,
            onPressed: () {
              _swipeAnimation();
            },
          )
        ]));

    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {});

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );

    bottom = new Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
  }

  Future<void> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  void _swap(DragUpdateDetails details) {
    matrix.translate(-details.globalPosition.dx, -details.globalPosition.dy);
    matrix.rotateZ(0.174533);
    matrix.translate(details.globalPosition.dx, details.globalPosition.dy);
    setState(() {});
  }

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(alignment: Alignment.center, children: cardList),
          ),
        ));
  }

  List<Widget> _getMatchCard() {
    var cards = new List<MatchCard>();
    cards.add(MatchCard(255, 0, 0, 10));
    cards.add(MatchCard(0, 255, 0, 20));
    cards.add(MatchCard(0, 0, 255, 30));

    var cardList = new List<Widget>();
    for (int x = 0; x < 3; x++) {
      cardList.add(
        Align(
          alignment: Alignment.center,
          child:
              // Draggable(
              //   onDragEnd: (drag) {
              //     _removeCard(x);
              //   },
              //   childWhenDragging: Container(),
              //   feedback: Card(
              //     elevation: 12,
              //     color: Color.fromARGB(255, cards[x].redColor, cards[x].greenColor,
              //         cards[x].blueColor),
              //     shape:
              //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //     child: Container(width: double.infinity, height: double.infinity),
              //   ),
              //   child:
              new Dismissible(
                  key: new Key(new Random().toString()),
                  crossAxisEndOffset: -0.1,
                  onResize: () {},
                  onDismissed: (direction) {
                    _removeCard(x);
                  },
                  child: new Transform(
                    // alignment: Alignment.bottomLeft,
                    transform: matrix,
                    child: new RotationTransition(
                      turns: new AlwaysStoppedAnimation(0),
                      // child: new Hero(
                      // tag: tag,
                      child: new GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          matrix.translate(-details.globalPosition.dx,
                              -details.globalPosition.dy);
                          matrix.rotateZ(0.174533);
                          matrix.translate(details.globalPosition.dx,
                              details.globalPosition.dy);
                          setState(() {});
                        },
                        child: Card(
                          elevation: 12,
                          color: Color.fromARGB(255, cards[x].redColor,
                              cards[x].greenColor, cards[x].blueColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                              width: double.infinity, height: double.infinity),
                        ),
                      ),
                      // ),
                    ),
                  )),
        ),
      );
    }

    return cardList;
  }

  void dismissImg(img) {}
}
