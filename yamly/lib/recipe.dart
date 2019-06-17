import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yamly/models/data.dart';
import 'package:yamly/models/recipe_model.dart';
import 'package:yamly/services/api_service.dart';
import 'package:yamly/values/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/product_model.dart';

class RecipeScreen extends StatefulWidget {
  @override
  RecipeScreenState createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  RecipeModel _recipe;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _recipe = data.recipe;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadRecipe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: _isLoading
                ? progressWidget()
                : (_recipe != null)
                    ? mainWidget(_recipe)
                    : placeholderWidget()));
  }

  Widget mainWidget(RecipeModel recipe) {
    return Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
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
                          padding: EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Center(
                                child: Text(recipe.title.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'NoTime', fontSize: 40)),
                              )),
                              SizedBox(height: 20),
                              Text(
                                "INGREDIENTS:",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'NoTime',
                                    fontSize: 30),
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                    getIngredients(recipe.products)
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: 'NoTime', fontSize: 20),
                                    textAlign: TextAlign.left),
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10))),
                                      color: Theme.of(context).canvasColor,
                                      child: Center(
                                          child: Icon(Icons.replay,
                                              color: Colors.orangeAccent)),
                                      onPressed: () => loadRecipe(),
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
                                          borderRadius: BorderRadius.only(
                                              bottomRight:
                                                  Radius.circular(10))),
                                      color: Theme.of(context).canvasColor,
                                      child: Center(
                                          child: Icon(Icons.favorite,
                                              color: Colors.redAccent)),
                                      onPressed: () => loadRecipe(),
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
                child: Text("Let's cook"),
                onPressed: () async => await _launchUrl(recipe.directions),
              ),
            ),
          ],
        ));
  }

  Widget placeholderWidget() {
    return Center(
        child: Text("Not enough data to generate a recipe\nGo swipe some more!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Theme.of(context).primaryColor)));
  }

  Widget progressWidget() {
    return Center(child: CustomWidgets.progressIndicator());
  }

  String getIngredients(List<ProductModel> products) {
    var ingredients = '';

    for (var product in products) {
      ingredients += '- ${product.name}\n';
    }

    return ingredients;
  }

  Future loadRecipe() async {
    setState(() {
      _isLoading = true;
    });

    await APIService().fetchRecipe();

    if (mounted) {
      setState(() {
        _isLoading = false;
        _recipe = data.recipe;
      });
    }
  }

  Future _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
