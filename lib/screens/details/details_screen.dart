import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/models/product.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';

import '../cart/cart_screen.dart';
import 'widgets/colors_radio_group.dart';

class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({
    required this.product,
    Key? key,
  }) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = ref.watch(cartProvider).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          Badge.count(
            count: totalItems,
            offset: const Offset(-3, 0),
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_shopping_cart_rounded),
        onPressed: () {
          ref.read(cartProvider.notifier).addCartItem(product);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: kDefaultPaddin,
              right: kDefaultPaddin * 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: product.id,
                  child: const FadeInImage(
                    width: 200,
                    image: /*NetworkImage(product.imageUrl),*/
                        AssetImage('assets/images/bag_6.png'),
                    placeholder: AssetImage('assets/images/bag_6.png'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    product.description,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color.fromARGB(137, 26, 25, 25),
                        ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(kDefaultPaddin / 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    '\$ ' + product.price.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'choose a color',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: kDefaultPaddin / 2),
                    const ColorsGroup(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
