import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';

import '../../constans.dart';
import '../../models/product/product.dart';
import '../../screens/details/details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    required this.product,
    this.showCartIcon = true,
    this.width = 120,
    super.key,
  });
  final Product product;
  final bool showCartIcon;
  final double width;
  @override
  Widget build(BuildContext context) {
    // final heroTag = '${ModalRoute.of(context)!.settings.name}-${product.id}';
    return SizedBox(
      width: 120,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'details'),
              builder: (ctx) => DetailsScreen(
                product: product,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 4.5),
          child: Column(
            children: [
              if (showCartIcon)
                Align(
                  alignment: Alignment.topCenter,
                  child: Consumer(builder: (context, ref, child) {
                    return IconButton.filledTonal(
                      style: const ButtonStyle().copyWith(
                        minimumSize: const MaterialStatePropertyAll(
                          Size.square(30),
                        ),
                      ),
                      onPressed: () {
                        ref.read(cartProvider.notifier).addCartItem(product);
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart_outlined,
                        size: kDefaultPadding,
                      ),
                    );
                  }),
                ),
              SizedBox(
                height: 100,
                child: FittedBox(
                  child: Hero(
                    tag: product.id,
                    child: FadeInImage(
                      fit: BoxFit.contain,
                      width: 100,
                      height: 100,
                      image: CachedNetworkImageProvider(product.imageUrl),
                      // AssetImage('assets/images/bag_6.png'),
                      placeholder:
                          const AssetImage(kPlaceholderAndErrorAssetImage),
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset(kPlaceholderAndErrorAssetImage),
                    ),
                  ),
                ),
              ),

              // Image.network(
              //   product.imageUrl,
              //   fit: BoxFit.contain,
              //   width: 100,
              //   height: 100,
              // ),

              const Gap(10),
              Text(
                product.title,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              const Gap(10),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      // color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      // color: Colors.black54,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
