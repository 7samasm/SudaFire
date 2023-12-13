import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../constans.dart';
import 'product_list_horizon_scroll.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  Map<String, Object> _getCategoryStream(String category) {
    final fs = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .orderBy(
          'createdAt',
          // descending: true,
        )
        .limit(5);
    return {
      'stream': fs.snapshots(),
      'count': FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          .count()
          .get()
          .asStream(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final laptopStream = _getCategoryStream('laptops');
    final phonesStream = _getCategoryStream('phones');
    final clothesStream = _getCategoryStream('clothes');

    // print('===========> ${laptopStream["count"]}');

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
              children: [
                ProductListHorizonScroll(
                  laptopStream['stream'] as Stream,
                  laptopStream['count'] as Stream,
                ),
                ProductListHorizonScroll(
                  phonesStream['stream'] as Stream,
                  phonesStream['count'] as Stream,
                ),
                // ProductListHorizonScroll(
                //   clothesStream['stream'] as Stream,
                //   laptopStream['count']!,
                // ),

                // ProductListHorizonScroll(phonesStream['stream'] as Stream, ),
                // ProductListHorizonScroll(clothesStream['stream'] as Stream, ),
                const SizedBox(height: kDefaultPaddin + 10)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
