import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../constans.dart';
import '../../models/product/product.dart';
import '../../screens/details/details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
    this._product, {
    super.key,
  });
  final Product _product;
  @override
  Widget build(BuildContext context) {
    // final heroTag = '${ModalRoute.of(context)!.settings.name}-${_product.id}';
    return SizedBox(
      width: 120,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'details'),
              builder: (ctx) => DetailsScreen(
                product: _product,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 4),
          child: DecoratedBox(
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 3),
              child: Column(
                children: [
                  Hero(
                    tag: _product.id,
                    child: FadeInImage(
                      fit: BoxFit.contain,
                      width: 100,
                      height: 100,
                      image: NetworkImage(_product.imageUrl),
                      // AssetImage('assets/images/bag_6.png'),
                      placeholder: const AssetImage('assets/images/bag_6.png'),
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/bag_6.png'),
                    ),
                  ),

                  // Image.network(
                  //   _product.imageUrl,
                  //   fit: BoxFit.contain,
                  //   width: 100,
                  //   height: 100,
                  // ),

                  const Gap(10),
                  Text(
                    _product.title,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  const Gap(10),
                  Text(
                    '\$${_product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          // color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
