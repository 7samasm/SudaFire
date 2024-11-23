import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_fire/screens/cart/models/cart_item.dart';
import 'package:shop_fire/models/product/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addCartItem(Product product) async {
    final indexOfCartItem =
        state.indexWhere((stateEl) => stateEl.product == product);
    if (indexOfCartItem > -1) {
      updateQuantity(product: product);
    } else {
      var items = [...state, CartItem(product: product)];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('cart-items', json.encode(items));
      state = items;
    }
  }

  void updateQuantity({
    required product,
    int amount = 1,
    bool isAddstion = true,
  }) async {
    var updatedItem = state.map(
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart-items', json.encode(updatedItem));
    state = updatedItem;
  }

  void deleteCartItem(CartItem cartItem) async {
    var filteredItems = state.where((stateEl) => stateEl != cartItem).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart-items', json.encode(filteredItems));
    state = filteredItems;
  }

  void loadCartItems() async {
    print('loadCartItems() called');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('cart-items') == null) {
      state = [];
    }
    var decodedItems =
        (json.decode(prefs.get('cart-items').toString()) as List<dynamic>)
            .map((e) => CartItem.fromJson(e))
            .toList();
    state = decodedItems;
  }

  void clearCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cart-items');
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);
