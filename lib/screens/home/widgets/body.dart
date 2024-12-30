import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shop_fire/constans.dart';
import '../../../widgets/product_list_horizon_scroll/product_list_horizontal_scroll.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        //   child: Text(
        //     "Women",
        //     style: Theme.of(context)
        //         .textTheme
        //         .headlineSmall!
        //         .copyWith(fontWeight: FontWeight.bold),
        //   ),
        // ),
        // const CategoriesList(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductListHorizontalScroll(
                  category: 'laptops',
                  title: 'laptops'.tr(),
                ),
                const Gap(kDefaultPadding * 2.5),
                ProductListHorizontalScroll(
                  category: 'phones',
                  title: 'phones'.tr(),
                ),
                const Gap(kDefaultPadding * 2.5),
                ProductListHorizontalScroll(
                  category: 'clothes',
                  title: 'clothes'.tr(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
