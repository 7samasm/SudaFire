import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartTile extends ConsumerWidget {
  const CartTile({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const FadeInImage(
        image: /* NetworkImage(cartItem.product.imageUrl), */
            AssetImage('assets/images/bag_6.png'),
        placeholder: AssetImage('assets/images/bag_6.png'),
      ),
      title: Text(cartItem.product.title),
      subtitle: Text(
        '\$${cartItem.product.price * cartItem.quantity} / ${cartItem.intQty} qty',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              ref
                  .read(cartProvider.notifier)
                  .updateQuantity(product: cartItem.product);
            },
            icon: const Icon(Icons.add),
          ),
          Text(
            '${cartItem.intQty}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            onPressed: () {
              if (cartItem.intQty == 1) {
                return;
              }
              ref
                  .read(cartProvider.notifier)
                  .updateQuantity(product: cartItem.product, isAddstion: false);
            },
            icon: const Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {
              ref.read(cartProvider.notifier).deleteCartItem(cartItem);
            },
            icon: const Icon(
              Icons.delete_outline_rounded,
            ),
          )
        ],
      ),
    );
  }
}
