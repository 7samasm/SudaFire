import 'package:flutter/material.dart';
import '../../../constans.dart';
import '../../../widgets/product_list_horizon_scroll/product_list_horizon_scroll.dart';

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
                buildScrollTitle('laptops', context),
                const ProductListHorizonScroll('laptops'),
                buildScrollTitle('phones', context),
                const ProductListHorizonScroll('phones'),
                // ProductListHorizonScroll('clothes'),
                const SizedBox(height: kDefaultPaddin + 10)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Padding buildScrollTitle(String text, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: kDefaultPaddin),
    child: Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 3),
    ),
  );
}
