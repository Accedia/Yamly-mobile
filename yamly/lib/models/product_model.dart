class ProductModel
{
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  ProductModel({this.description, this.imageUrl, this.name, this.id});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl']
    );
  }
}