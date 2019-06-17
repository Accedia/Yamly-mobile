import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding:
                    EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orangeAccent,
                                boxShadow: [
                                  new BoxShadow(
                                    offset: Offset(0, 10),
                                    color: Colors.black26,
                                    blurRadius: 10.0,
                                  ),
                                ]),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 15, right: 15, bottom: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          child: Center(
                                        child: Text("Best recipe",
                                            style: TextStyle(
                                                fontFamily: 'LemonJelly',
                                                fontSize: 60)),
                                      )),
                                      Text(
                                        "Ingredients:",
                                        style: TextStyle(
                                            fontFamily: 'LemonJelly',
                                            fontSize: 40),
                                        textAlign: TextAlign.left,
                                      ),
                                      Transform.translate(
                                        offset: Offset(0, -10),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text("◦ Aasd\n◦ Bbsd\n◦ Ccsd",
                                              style: TextStyle(
                                                  fontFamily: 'LemonJelly',
                                                  fontSize: 30,
                                                  height: 0.7),
                                              textAlign: TextAlign.left),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            child: FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10))),
                                              color:
                                                  Theme.of(context).canvasColor,
                                              child: Center(
                                                  child: Icon(Icons.replay,
                                                      color:
                                                          Colors.orangeAccent)),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                        Container(
                                            width: 0.5,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .unselectedWidgetColor)),
                                        Expanded(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            child: FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                              color:
                                                  Theme.of(context).canvasColor,
                                              child: Center(
                                                  child: Icon(Icons.favorite,
                                                      color: Colors.redAccent)),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      elevation: 7,
                      color: Theme.of(context).primaryColor,
                      clipBehavior: Clip.antiAlias,
                      child: MaterialButton(
                        minWidth: 200,
                        padding: EdgeInsets.all(15),
                        textColor: Colors.white,
                        child: Text("Cook now!"),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ))));
  }
}
