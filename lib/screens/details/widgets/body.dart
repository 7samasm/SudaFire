import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
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
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            margin: EdgeInsets.only(
                top: (MediaQuery.of(context).size.height) * 0.3),
            child: Column(
              children: [
                const Gap(kDefaultPadding * 2),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: '${'price'.tr()}\n',
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
                            'choose a color'.tr(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const Gap(10),
                          const ColorsGroup(),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(kDefaultPadding * 3.5),
                ProductListHorizontalScroll(
                  category: 'laptops',
                  title: 'see also'.tr(),
                  pageTitle: product.title,
                ),
                const Gap(kDefaultPadding * 2.5),
                ProductListHorizontalScroll(
                  category: 'phones',
                  title: 'related'.tr(),
                  pageTitle: product.title,
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Gap(kDefaultPadding),
              Padding(
                padding: const EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding * 2,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: product.id,
                      child: FadeInImage(
                        width: 220,
                        image: CachedNetworkImageProvider(product.imageUrl),
                        // AssetImage('assets/images/bag_6.png'),
                        placeholder:
                            const AssetImage(kPlaceholderAndErrorAssetImage),
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset(kPlaceholderAndErrorAssetImage),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        product.description,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
