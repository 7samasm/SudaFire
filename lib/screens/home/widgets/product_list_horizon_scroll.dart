import 'package:flutter/material.dart';

import 'package:shop_fire/screens/home/widgets/product_item.dart';

import '../../../constans.dart';
import '../../../models/product.dart';

class ProductListHorizonScroll extends StatefulWidget {
  const ProductListHorizonScroll(
    this.stream,
    this.count, {
    super.key,
  });

  // final Map<String, dynamic> data;

  final Stream stream;
  final Stream count;

  @override
  State<ProductListHorizonScroll> createState() =>
      _ProductListHorizonScrollState();
}

class _ProductListHorizonScrollState extends State<ProductListHorizonScroll> {
  final List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  int _totalPages = 2;

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

  _fetch() async {
    print(widget.count.toString());
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    // _products.addAll(widget.data['products']);
    // _totalPages =
    //     ((widget.data['count'] as int) / kDefaultHomeLimitPage).ceil();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print([..._products, 'zzz']);
    return StreamBuilder(
        stream: widget.stream,
        builder: (context, productSnapShots) {
          if (!productSnapShots.hasData) {
            return const Text('empty ...');
          }
          if (productSnapShots.connectionState == ConnectionState.waiting) {
            return const Text('...wating');
          }
          if (productSnapShots.hasError) {
            return const Text('something goes wrong');
          }

          final products = productSnapShots.data!.docs
              .map(
                (e) => Product(
                  title: e.data()['title'],
                  price: e.data()['price'],
                  description: e.data()['description'],
                  imageUrl: e.data()['imageUrl'],
                  category: e.data()['category'],
                  createdAt: e.data()['createdAt'].toString(),
                ),
              )
              .toList();

          return Padding(
            padding: const EdgeInsets.only(left: kDefaultPaddin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kDefaultPaddin + 10),
                Text(products[0].category),
                StreamBuilder(
                  stream: widget.count,
                  builder: (context, snapshot) {
                    return Text('${snapshot.data.count.toString()} results');
                  },
                ),
                const SizedBox(height: kDefaultPaddin / 2),
                SizedBox(
                  height: 200,
                  // width: 200,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length + 1,
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
                      if (i == products.length) {
                        return const SeeAllButton();
                      }
                      if (i <= products.length - 1) {
                        final product = products[i];
                        return ProductItem(product);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
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
