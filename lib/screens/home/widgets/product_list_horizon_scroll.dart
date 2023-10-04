import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shop_fire/screens/home/widgets/product_item.dart';

import '../../../constans.dart';
import '../../../models/product.dart';

class ProductListHorizonScroll extends StatefulWidget {
  const ProductListHorizonScroll(
    this.data, {
    super.key,
  });

  final Map<String, dynamic> data;

  @override
  State<ProductListHorizonScroll> createState() =>
      _ProductListHorizonScrollState();
}

class _ProductListHorizonScrollState extends State<ProductListHorizonScroll> {
  final List<dynamic> _products = [];
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  int _totalPages = 1;

  _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      if (_page == _totalPages) {
        return;
      }
      _page++;
      _fetch();
    }
  }

  _fetch() async {}

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _products.addAll(widget.data['products']);
    _totalPages =
        ((widget.data['count'] as int) / kDefaultHomeLimitPage).ceil();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print([..._products, 'zzz']);
    return Padding(
      padding: const EdgeInsets.only(left: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kDefaultPaddin + 10),
          Text(widget.data['category']),
          const SizedBox(height: kDefaultPaddin / 2),
          SizedBox(
            height: 200,
            // width: 200,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _products.length + 1,
              itemBuilder: (ctx, i) {
                // print(
                //   '(${widget.data['category']}) page=$_page and total_pages=$_totalPages',
                // // );
                // if (i == _products.length && _page < _totalPages) {
                //   return const Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 30),
                //     child: Center(
                //       child: CircularProgressIndicator(),
                //     ),
                //   );
                // }
                if (i == _products.length) {
                  return const SeeAllButton();
                }
                if (i <= _products.length - 1) {
                  final product = _products[i];
                  return ProductItem(
                    Product(
                      title: product['title'],
                      description: product['description'],
                      category: product['category'],
                      imageUrl: product['imageUrl'],
                      price: double.parse(product['price'].toString()),
                      createdAt: product['createdAt'],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SeeAllButton extends StatelessWidget {
  const SeeAllButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: kDefaultPaddin,
        left: kDefaultPaddin / 4,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_forward_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            // const SizedBox(height: 5),
            Text(
              'see all',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
