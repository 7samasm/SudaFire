import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/providers/favorite_provider.dart';
import 'package:shop_fire/widgets/product_card_item/product_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('favoriets'),
      ),
      body: Consumer(builder: (context, ref, _) {
        final favs = ref.watch(favoriteProvider);
        if (favs.isEmpty) {
          return const Center(
            child: Text('no fav added yet'),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(kDefaultPadding),
          itemCount: favs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            mainAxisSpacing: kDefaultPadding / 3,
            crossAxisSpacing: kDefaultPadding / 3,
          ),
          itemBuilder: (context, index) {
            return Card(
              child: ProductItem(
                product: favs[index],
                showCartIcon: false,
              ),
            );
          },
        );
      }),
    );
  }
}
