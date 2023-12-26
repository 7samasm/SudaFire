import 'package:shop_fire/models/category.dart';

class Product {
  Product({
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.createdAt,
  }) : id = DateTime.now().toIso8601String();
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final double price;
  final String createdAt;

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      createdAt: json['createdAt'].toString(),
    );
  }
}

List<Product> dummyProducts = [
  Product(
    title: 'hp pavlion',
    description:
        'core i5 8gen lprem ipsom dollar site get it right now lprem ipsom dollar site get it right now lprem ipsom dollar site get it right now lprem ipsom dollar site lprem ipsom dollar site get it right now lprem ipsom dollar site',
    category: Categories.laptops.name,
    imageUrl: 'assets/images/bag_1.png',
    price: 1200,
    createdAt: DateTime.now().toString(),
  ),
  Product(
    title: 'Android T-shirt',
    description: 'white',
    category: Categories.dresses.name,
    imageUrl: 'assets/images/bag_2.png',
    price: 300,
    createdAt: DateTime.now().toString(),
  ),
  Product(
    title: 'Samsumg A71',
    description: '128/6',
    category: Categories.smartphones.name,
    imageUrl: 'assets/images/bag_3.png',
    price: 1200,
    createdAt: DateTime.now().toString(),
  ),
  Product(
    title: 'lenovo thinkpad',
    description: 'core i7 16gen',
    category: Categories.laptops.name,
    imageUrl: 'assets/images/bag_4.png',
    price: 2000,
    createdAt: DateTime.now().toString(),
  ),
  Product(
    title: 'redmi note 11s',
    description: '256/8',
    category: Categories.smartphones.name,
    imageUrl: 'assets/images/bag_5.png',
    price: 1200,
    createdAt: DateTime.now().toString(),
  ),
  Product(
    title: 'golden ring',
    description: 'simple goledn ring sdhsdj dhjsdh nbdsnd ndsnd nsbdns nsdbn',
    category: Categories.jewellery.name,
    imageUrl: 'assets/images/bag_6.png',
    price: 1200,
    createdAt: DateTime.now().toString(),
  )
];
