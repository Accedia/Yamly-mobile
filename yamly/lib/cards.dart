import 'dart:math';
import 'package:yamly/match_card.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Widget> cardList;

  @override
  void initState() {
    super.initState();
    cardList = _getMatchCard();
  }

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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
          child: new Dismissible(
            key: new Key(new Random().toString()),
            crossAxisEndOffset: -0.1,
            onResize: () {},
            onDismissed: (direction) {
              _removeCard(x);
            },
            child: Card(
              elevation: 12,
              color: Color.fromARGB(255, cards[x].redColor, cards[x].greenColor,
                  cards[x].blueColor),
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
                        onPressed: () {}
                      )
                    ]),
              ),
            ),
          ),
        ),
      );
    }

    return cardList;
  }
}
