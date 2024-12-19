import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/models/product/product.dart';
import 'package:shop_fire/providers/favorite_provider.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';
import 'package:shop_fire/screens/details/widgets/body.dart';
import 'package:shop_fire/screens/home/home_screen.dart';

import '../cart/cart_screen.dart';

class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({
    required this.product,
    super.key,
  });
  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = ref.watch(cartProvider).length;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            icon: const Icon(Icons.home),
          ),
          Consumer(builder: (context, ref, _) {
            final favs = ref.watch(favoriteProvider);
            return IconButton(
              onPressed: () {
                ref
                    .read(favoriteProvider.notifier)
                    .toggleFavoriteProduct(product);
              },
              icon: Icon(favs.contains(product)
                  ? Icons.favorite
                  : Icons.favorite_border_outlined),
            );
          }),
          Badge.count(
            count: totalItems,
            offset: const Offset(-3, 0),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            isLabelVisible: totalItems >= 1,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_shopping_cart_rounded),
        onPressed: () {
          ref.read(cartProvider.notifier).addCartItem(product);
        },
      ),
      body: Body(product),
    );
  }
}
