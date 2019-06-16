import 'dart:convert';

import 'package:yamly/models/data.dart';
import 'package:yamly/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:yamly/values/urls.dart';

class APIService{
  dynamic _extractData(http.Response resp) => json.decode(resp.body);

  Exception _handleError(dynamic e) {
    return Exception('Server error; cause: $e');
  }

  Future<void> addProduct() async{
    var newProducts = await fetchProducts();
    if (newProducts != null){
      data.products.addAll(newProducts);
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    try{
      final response = await http.get(Urls.randomProducts);
      if (response.statusCode == 200) {
        var productList = (_extractData(response) as List)
              .map((value) => ProductModel.fromJson(value)).toList();
        return productList;
      } else {
        return null;
      }
    } catch (e) {
      throw _handleError(e);
    }
  }
}