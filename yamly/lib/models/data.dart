import 'package:firebase_auth/firebase_auth.dart';
import 'package:yamly/models/product_model.dart';
import 'package:yamly/models/recipe_model.dart';

class Data {
  FirebaseUser user;
  List<ProductModel> products = new List<ProductModel>();
  RecipeModel recipe;

  clear() {
    user = null;
    products = new List<ProductModel>();
    recipe = null;
  }
}

final Data data = Data();