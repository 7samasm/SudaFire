import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'cart_tile.dart';

class CartListItems extends StatefulWidget {
  const CartListItems({super.key});

  @override
  State<CartListItems> createState() => _CartListItemsState();
}

class _CartListItemsState extends State<CartListItems> {
  final _listKey = GlobalKey<AnimatedListState>();

  _onCartItemDeleted({required index, CartItem? cartItem}) {
    _listKey.currentState!.removeItem(
      index,
      duration: const Duration(milliseconds: 400),
      (context, animation) {
        if (cartItem != null) {
          return FadeTransition(
            opacity: animation,
            child: AbsorbPointer(
              child: CartTile(
                cartItem: cartItem,
                onCartItemRemoved: () {},
              ),
            ),
          );
        }
        return const Spacer();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final cartItems = ref.watch(cartProvider);
        return AnimatedList(
          key: _listKey,
          initialItemCount: cartItems.length,
          itemBuilder: (context, i, animation) {
            return Dismissible(
              key: ValueKey(cartItems[i].product.id),
              direction: DismissDirection.startToEnd,
              onDismissed: (dir) {
                ref.read(cartProvider.notifier).deleteCartItem(cartItems[i]);
                _onCartItemDeleted(index: i);
              },
              child: CartTile(
                cartItem: cartItems[i],
                onCartItemRemoved: () {
                  _onCartItemDeleted(index: i, cartItem: cartItems[i]);
                },
              ),
            );
          },
        );
      },
    );
  }
}
