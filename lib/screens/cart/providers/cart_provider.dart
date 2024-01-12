import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/screens/cart/models/cart_item.dart';
import 'package:shop_fire/models/product/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addCartItem(Product product) {
    final indexOfCartItem =
        state.indexWhere((stateEl) => stateEl.product == product);
    if (indexOfCartItem > -1) {
      updateQuantity(product: product);
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void updateQuantity({
    required product,
    int amount = 1,
    bool isAddstion = true,
  }) {
    state = state.map(
      (stateEl) {
        var qty = stateEl.quantity + amount;
        if (!isAddstion) {
          qty = stateEl.quantity - amount;
        }
        return stateEl.product == product
            ? CartItem(product: product, quantity: qty)
            : stateEl;
      },
    ).toList();
  }

  void deleteCartItem(CartItem cartItem) {
    state = state.where((stateEl) => stateEl != cartItem).toList();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);
