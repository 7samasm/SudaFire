import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../constans.dart';
import 'product_list_horizon_scroll.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (context, productSnapShots) {
          if (!productSnapShots.hasData) {
            return const Text('empty ...');
          }
          if (productSnapShots.hasError) {
            return const Text('something goes wrong');
          }
          final products = productSnapShots.data!.docs
              .map(
                (e) => {
                  'title': e.data()['title'],
                  'price': e.data()['price'],
                  'description': e.data()['description'],
                  'imageUrl': e.data()['imageUrl'],
                  'category': e.data()['category'],
                  'createdAt': e.data()['createdAt'].toString(),
                },
              )
              .toList();

          List<Map<String, Object>> data = getData(products);
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
                      for (var item in data) ProductListHorizonScroll(item),
                      const SizedBox(height: kDefaultPaddin + 10)
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  List<Map<String, Object>> getData(List<Map<String, dynamic>> products) {
    final laptops = products.where((el) => el['category'] == 'laptops');
    final phones = products.where((el) => el['category'] == 'phones');
    // print(products);
    final data = [
      {
        'count': laptops.length,
        'category': 'laptops',
        'products': laptops,
      },
      {
        'count': phones.length,
        'category': 'phones',
        'products': phones,
      }
    ];
    return data;
  }
}
