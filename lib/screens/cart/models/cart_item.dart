import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:shop_fire/models/product/product.dart';

part 'cart_item.freezed.dart';

// part 'person.g.dart';

@freezed
class CartItem with _$CartItem {
  CartItem._();
  factory CartItem({
    @Default(1) int quantity,
    required Product product,
  }) = _CartItem;

  double get totalUnitsPrice => product.price * quantity.toDouble();
}
