import 'package:flutter/material.dart';
import '../../../widgets/product_list_horizon_scroll/product_list_horizon_scroll.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
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
                ProductListHorizonScroll(category: 'laptops', title: 'laptops'),
                // ProductListHorizonScroll(category: 'phones', title: 'phones'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
