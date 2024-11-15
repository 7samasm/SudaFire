import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shop_fire/models/product/product.dart';

import '../../../constans.dart';
import '../../../widgets/product_list_horizon_scroll/product_list_horizontal_scroll.dart';
import 'colors_radio_group.dart';

class Body extends StatelessWidget {
  const Body(this.product, {super.key});
  final Product product;
  @override
  Widget build(BuildContext context) {
    // final args = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
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
                  child: FadeInImage(
                    width: 200,
                    image: NetworkImage(product.imageUrl),
                    // AssetImage('assets/images/bag_6.png'),
                    placeholder: const AssetImage('assets/images/bag_6.png'),
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/bag_6.png'),
                  ),
                ),
                const Gap(10),
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
                Text.rich(
                  TextSpan(
                    text: 'price\n',
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        text: '\$ ${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    ],
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
                    const Gap(10),
                    const ColorsGroup(),
                  ],
                ),
              ],
            ),
          ),
          const Gap(60),
          ProductListHorizontalScroll(
            category: 'laptops',
            title: 'see also',
            pageTitle: product.title,
          ),
          ProductListHorizontalScroll(
            category: 'phones',
            title: 'related',
            pageTitle: product.title,
          ),
        ],
      ),
    );
  }
}
