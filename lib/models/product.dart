class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.createdAt,
  }); //: id = DateTime.now().toIso8601String();
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final double price;
  final String createdAt;

  factory Product.fromMap(Map<String, dynamic> json, String id) {
    return Product(
      id: id,
      title: json['title'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      createdAt: json['createdAt'].toString(),
    );
  }
}
