import 'package:flutter/material.dart';

class ProductInfoPage extends StatelessWidget {
  final String tag;

  const ProductInfoPage({Key key, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: Column(
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: tag,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green
                  ),
                  // child: Image.network(
                  //   'https://picsum.photos/250?image=9',
                  // )
                ),
              ),
            ),
            Container(
              color: Colors.black87,
              child: SafeArea(
                top: false,
                child: Padding(padding: EdgeInsets.symmetric(),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: "Text" + tag,
                        child: Material(
                          color: Colors.black87,
                          child: ListTile(
                              title: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text("Name", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)
                              )),
                              trailing: IconButton(color: Colors.white, icon: Icon(Icons.arrow_drop_down), onPressed: (){
                                  Navigator.pop(context);
                              }),
                      ))),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                        child: Text("More info about this foodMore info about this food\nMore info about this food\nMore info about this food",
                          style: TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              )),
            )
          ]
      )
    ), 
    onWillPop: () async {
      if (Navigator.of(context).userGestureInProgress)
        return false;
      else
        return true;
    });
  }
}
