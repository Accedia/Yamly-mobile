import 'dart:math';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Widget> _cards;

  @override
  void initState() {
    super.initState();
    _cards = _getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(alignment: Alignment.center, children: _cards),
          ),
        ));
  }

  List<Widget> _getCards() {
    var cards = List<Widget>();

    for (int x = 0; x < 30; x++) {
      cards.add(
        Align(
          alignment: Alignment.center,
          child: Dismissible(
            key: Key(Random().toString()),
            crossAxisEndOffset: -0.1,
            onResize: () {},
            onDismissed: (direction) {
              _removeCard(x);
            },
            child: Card(
              elevation: 12,
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                  .withOpacity(1.0),
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
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.arrow_right, color: Colors.white),
                          iconSize: 50,
                          onPressed: () {})
                    ]),
              ),
            ),
          ),
        ),
      );
    }

    return cards;
  }

  void _removeCard(index) {
    setState(() {
      _cards.removeAt(index);
    });
  }
}
