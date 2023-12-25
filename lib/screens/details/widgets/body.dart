import 'package:flutter/material.dart';
import 'package:shop_fire/models/product.dart';

import '../../../constans.dart';
import '../../../widgets/product_list_horizon_scroll/product_list_horizon_scroll.dart';
import '../../home/widgets/body.dart';
import 'colors_radio_group.dart';

class Body extends StatelessWidget {
  const Body(this.product, {Key? key}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: kDefaultPaddin * 3),
          buildScrollTitle('see also', context),
          ProductListHorizonScroll('laptops'),
          buildScrollTitle('related', context),
          ProductListHorizonScroll('laptops'),
        ],
      ),
    );
  }
}
