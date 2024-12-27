import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop_fire/widgets/matreial_dialog.dart';

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
    return MaterialDialog(
      title: 'Summary',
      leadingTextActions: Text.rich(
        TextSpan(
          text: 'total\n',
          style: Theme.of(context).textTheme.bodySmall,
          // .copyWith(color: Colors.black54),
          children: [
            TextSpan(
              text: totalPrice.toStringAsFixed(2),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    // color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      content: Column(
        children: [
          Expanded(
            child: ListWheelScrollView(
              itemExtent: 55.0,
              diameterRatio: 1.5,
              children: [
                for (var cartItem in cartItems)
                  ListTile(
                    leading: Badge(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      largeSize: 20,
                      label: Text(
                        cartItem.quantity.toStringAsFixed(0),
                      ),
                      child: FadeInImage(
                          image: CachedNetworkImageProvider(
                              cartItem.product.imageUrl),
                          // AssetImage('assets/images/bag_6.png'),
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Image.asset(kPlaceholderAndErrorAssetImage),
                          placeholder:
                              const AssetImage(kPlaceholderAndErrorAssetImage)),
                    ),
                    title: Text(cartItem.product.title),
                    subtitle: Text(
                      '\$${cartItem.totalUnitsPrice}',
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
      passButton: TextButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text('pay'),
        icon: const Icon(Icons.payment_outlined),
        // style: TextButton.styleFrom(
        //     foregroundColor: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
