import 'package:shop_fire/models/product.dart';

class CartItem {
  CartItem({required this.product, this.quantity = 1})
      : id = DateTime.now().toIso8601String();
  final String id;
  final double quantity;
  final Product product;

  double get totalUnitsPrice => product.price * quantity;

  int get intQty => quantity.toInt();

  set quantity(double qty) {
    quantity = qty;
  }
}
