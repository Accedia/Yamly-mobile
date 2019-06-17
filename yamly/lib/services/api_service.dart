import 'dart:convert';

import 'package:yamly/models/data.dart';
import 'package:yamly/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:yamly/models/recipe_model.dart';
import 'package:yamly/values/urls.dart';

class APIService {
  static const int productsFetchNumber = 20;
  dynamic _extractData(http.Response resp) => json.decode(resp.body);

  Exception _handleError(dynamic e) {
    return Exception('Server error; cause: $e');
  }

  Future<void> addProduct() async {
    if (data.products.length < 2 * productsFetchNumber) {
      var newProducts = await fetchProducts();
      if (newProducts != null) {
        data.products.addAll(newProducts);
        addHotDog();
      }
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http.get(Urls.randomProducts);
      if (response.statusCode == 200) {
        var productList = (_extractData(response) as List)
            .map((value) => ProductModel.fromJson(value))
            .toList();
        return productList;
      } else {
        return null;
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future fetchRecipe() async {
    try {
      final response = await http.get('${Urls.randomRecipe}/${data.user.uid}');
      if (response.statusCode == 200) {
        data.recipe = RecipeModel.fromJson(_extractData(response));
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  addHotDog() {
    data.products.insert(
        10,
        ProductModel(
            id: 0,
            name: 'hot dog',
            description: '',
            imageUrl:
                'https://veggiedesserts.co.uk/wp-content/uploads/2018/04/Lentil-Carrot-Hot-Dogs-4B.jpg'));
  }
}
