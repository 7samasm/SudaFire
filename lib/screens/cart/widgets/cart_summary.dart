import 'package:cached_network_image/cached_network_image.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                  child: ListWheelScrollView(
                    itemExtent: 55.0,
                    diameterRatio: 1.5,
                    children: [
                      for (var cartItem in cartItems)
                        ListTile(
                          leading: Badge(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            largeSize: 20,
                            label: Text(
                              cartItem.quantity.toStringAsFixed(0),
                            ),
                            child: FadeInImage(
                                image: CachedNetworkImageProvider(
                                    cartItem.product.imageUrl),
                                // AssetImage('assets/images/bag_6.png'),
                                imageErrorBuilder: (context, error,
                                        stackTrace) =>
                                    Image.asset(kPlaceholderAndErrorAssetImage),
                                placeholder: const AssetImage(
                                    kPlaceholderAndErrorAssetImage)),
                          ),
                          title: Text(cartItem.product.title),
                          subtitle: Text(
                            '\$${cartItem.totalUnitsPrice}',
                          ),
                        )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 3.5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'total\n',
                          style: Theme.of(context).textTheme.bodySmall,
                          // .copyWith(color: Colors.black54),
                          children: [
                            TextSpan(
                              text: totalPrice.toStringAsFixed(2),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    // color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: const Text('pay'),
                        icon: const Icon(Icons.payment_outlined),
                        style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: const Text('cancel'),
                        icon: const Icon(Icons.clear_outlined),
                        style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary),
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
