import 'package:flutter/material.dart';

import '../../../constans.dart';
import '../models/cart_item.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  final List<CartItem> cartItems;
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          width: double.maxFinite,
          height: 400,
          child: Card(
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 80,
                  // padding: const EdgeInsets.only(left: kDefaultPaddin),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    'Summary',
                    textAlign: TextAlign.center,
                    // textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          height: 2.5,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final title = cartItems[index].product.title;
                      return ListTile(
                        leading: Badge(
                          label: Text(
                            cartItems[index].quantity.toStringAsFixed(0),
                          ),
                          child: CircleAvatar(
                            child: Text(
                              title.substring(0, 1).toUpperCase(),
                            ),
                          ),
                        ),
                        title: Text(title),
                        subtitle: Text(
                          '\$${cartItems[index].totalUnitsPrice}',
                        ),
                        // trailing: ActionChip(
                        //   backgroundColor:
                        //       Theme.of(context).colorScheme.secondary,
                        //   label: Text(
                        //       '${cartItems[index].quantity.toStringAsFixed(0)} qty'),
                        // ),
                      );
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(kDefaultPaddin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'total\n',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: totalPrice.toStringAsFixed(2),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {},
                        label: const Text('order'),
                        icon: const Icon(Icons.check),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
