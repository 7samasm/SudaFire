import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';
import 'package:shop_fire/screens/cart/widgets/cart_summary.dart';

import 'models/cart_item.dart';
import 'widgets/cart_tile.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  int _getTotalPrice(List<CartItem> cartItem) {
    double sum = 0;
    for (var element in cartItem) {
      sum += element.quantity * element.product.price;
    }
    return sum.toInt();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    Widget content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'total\n',
                        style: Theme.of(context).textTheme.bodyLarge),
                    TextSpan(
                      text: '\$${_getTotalPrice(cartItems)}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CartSummary(
                      cartItems: cartItems,
                      totalPrice: _getTotalPrice(cartItems),
                    ),
                  );
                },
                label: const Text('order'),
                icon: const Icon(Icons.add_task),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (ctx, i) => Dismissible(
              key: ValueKey(cartItems[i].id),
              direction: DismissDirection.startToEnd,
              onDismissed: (dir) {
                ref.read(cartProvider.notifier).deleteCartItem(cartItems[i]);
              },
              child: CartTile(cartItem: cartItems[i]),
            ),
          ),
        ),
      ],
    );

    if (cartItems.isEmpty) {
      content = const Center(
        child: Text('cart is empty right now!'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: content,
    );
  }
}
