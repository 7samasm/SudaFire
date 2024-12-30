import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
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
      title: 'Summary'.tr(),
      leadingTextActions: Text.rich(
        TextSpan(
          text: '${'total'.tr()}\n',
          style: Theme.of(context).textTheme.bodyMedium,
          // .copyWith(color: Colors.black54),
          children: [
            TextSpan(
              text: totalPrice.toStringAsFixed(2),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
      action: TextButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text('pay').tr(),
        icon: const Icon(Icons.payment_outlined),
      ),
    );
  }
}
