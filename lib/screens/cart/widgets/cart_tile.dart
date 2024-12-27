import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/screens/details/details_screen.dart';

import '../../../constans.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartTile extends ConsumerWidget {
  const CartTile({
    super.key,
    required this.cartItem,
    required this.onCartItemRemoved,
  });

  final CartItem cartItem;
  final Function onCartItemRemoved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('CartTile called');
    return ListTile(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(product: cartItem.product);
            },
          ),
        );
      },
      leading: FadeInImage(
        image: CachedNetworkImageProvider(cartItem.product.imageUrl),
        // AssetImage('assets/images/bag_6.png'),
        placeholder: const AssetImage(kPlaceholderAndErrorAssetImage),
        imageErrorBuilder: (context, error, stackTrace) =>
            Image.asset(kPlaceholderAndErrorAssetImage),
      ),
      title: Text(cartItem.product.title),
      subtitle: Text(
        '\$${cartItem.product.price * cartItem.quantity} / ${cartItem.quantity} qty',
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
            '${cartItem.quantity}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            onPressed: () {
              if (cartItem.quantity == 1) {
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
              onCartItemRemoved();
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
