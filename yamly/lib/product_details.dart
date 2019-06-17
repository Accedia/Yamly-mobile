import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:yamly/models/product_model.dart';

class ProductInfoPage extends StatelessWidget {
  final String tag;
  final ProductModel product;

  const ProductInfoPage({Key key, this.tag, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(children: <Widget>[
                Center(
                  child: Image.asset('images/logo.png')
                ),
                Hero(
                  tag: tag,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.topCenter,
                        image: NetworkImageWithRetry(product.imageUrl),
                      )
                    ),
                    // child: Image(
                    //   image: NetworkImageWithRetry(product.imageUrl),
                    // )
                  ),
                )
              ],),
            ),
            Container(
              color: Colors.black,
              child: SafeArea(
                top: false,
                child: Padding(padding: EdgeInsets.symmetric(),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: "Text" + tag,
                        child: Material(
                          color: Theme.of(context).primaryColor.withOpacity(0.9),
                          child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(25, 0, 15, 0),
                              title: Text(product.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              trailing: Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.white),
                              onTap: (){
                                Navigator.pop(context);
                              },
                      ))),
                      Container(
                        color: Colors.orangeAccent[100],
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                        child: Text(product.description),
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
