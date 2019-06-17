import 'package:yamly/models/product_model.dart';

class RecipeModel {
  final int id;
  final String title;
  final List<ProductModel> products;
  final String directions;

  RecipeModel({this.id, this.title, this.products, this.directions});

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
        id: json['id'],
        title: json['title'],
        products: (json['products'] as List)
            .map((value) => ProductModel.fromJson(value))
            .toList(),
        directions: json['directions']);
  }
}
