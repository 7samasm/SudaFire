import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';
import 'package:shop_fire/screens/cart/widgets/cart_list_items.dart';
import 'package:shop_fire/screens/cart/widgets/cart_summary.dart';

import 'models/cart_item.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  int _getTotalPrice(List<CartItem> cartItem) {
    double sum = 0;
    for (var element in cartItem) {
      sum += element.quantity * element.product.price;
    }
    return sum.toInt();
  }

  @override
  Widget build(BuildContext context, ref) {
    final cartItems = ref.watch(cartProvider);
    // print('CartScreen called');

    Widget content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(
                  text: '${'total'.tr()}\n',
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: '\$${_getTotalPrice(cartItems)}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, a1, a2) => Consumer(
                      builder: (context, ref, child) {
                        final cartItems = ref.watch(cartProvider);
                        return CartSummary(
                          cartItems: cartItems,
                          totalPrice: _getTotalPrice(cartItems),
                        );
                      },
                    ),
                  );
                },
                label: const Text('order').tr(),
                icon: const Icon(Icons.add_task),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      padding: const EdgeInsets.all(0),
                      onTap: () {
                        ref.read(cartProvider.notifier).clearCartItems();
                      },
                      child: ListTile(
                        dense: true,
                        leading: const Icon(Icons.delete_forever_outlined),
                        title: const Text('delete all').tr(),
                      ),
                    ),
                  ];
                },
              )
            ],
          ),
        ),
        const Expanded(
          child: CartListItems(),
        ),
      ],
    );

    if (cartItems.isEmpty) {
      content = AlertDialog(
        title: const Text('oops'),
        // actionsPadding: const EdgeInsets.all(10),
        contentTextStyle: Theme.of(context).textTheme.titleMedium,
        content: const Text('cart is empty right now!'),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('ok'),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart').tr(),
      ),
      body: content,
    );
  }
}
