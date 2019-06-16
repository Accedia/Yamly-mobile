import 'package:firebase_auth/firebase_auth.dart';
import 'package:yamly/models/product_model.dart';

class Data {
  FirebaseUser user;
  List<ProductModel> products = new List<ProductModel>();
}

final Data data = Data();