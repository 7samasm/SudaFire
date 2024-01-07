import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:shop_fire/widgets/product_card_item/product_item.dart';
import 'package:shop_fire/widgets/product_list_horizon_scroll/product_list_loader.dart';

import '../../constans.dart';
import '../../models/product.dart';

class ProductListHorizonScroll extends StatefulWidget {
  const ProductListHorizonScroll({
    required this.category,
    required this.title,
    super.key,
  });

  // final Map<String, dynamic> data;

  final String category;
  final String title;

  @override
  State<ProductListHorizonScroll> createState() =>
      _ProductListHorizonScrollState();
}

class _ProductListHorizonScrollState extends State<ProductListHorizonScroll> {
  // ignore: prefer_final_fields
  List<Product> _products = [];
  static const kPageSize = 5;
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;
  int _totalResults = 0;
  int _page = 1;
  int get _totalPages => (_totalResults / kPageSize).ceil();

  Future<void> _fetchFirebaseData() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    //query
    Query query = FirebaseFirestore.instance
        .collection("products")
        .where('category', isEqualTo: widget.category)
        .orderBy('createdAt');
    // get total count before limit  from query above
    if (_lastDocument != null) {
      var count = (await query.count().get()).count;

      setState(() {
        _totalResults = count;
      });
    }

    // get first result or next page depending on last doc exitence
    query = _lastDocument != null
        ? query.startAfterDocument(_lastDocument!).limit(kPageSize)
        : query.limit(kPageSize);

    final value = await query.get();

    // get last doc if fetched result not empty
    _lastDocument = value.docs.isNotEmpty ? value.docs.last : null;

    final List<Product> fetchedProducts = value.docs
        .map((e) => Product.fromMap(e.data() as Map<String, dynamic>))
        .toList();

    setState(
      () {
        _products.addAll(fetchedProducts);
        _isLoading = false;
      },
    );
  }

  @override
  void initState() {
    _fetchFirebaseData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print([..._products, 'zzz']);
    return Padding(
      padding: const EdgeInsets.only(left: kDefaultPaddin),
      child: _products.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(height: 3),
                ),
                Text('$_totalResults results'),
                SizedBox(
                  height: 180,
                  // width: 200,
                  child: NotificationListener<ScrollEndNotification>(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _products.length + 1,
                      itemBuilder: (ctx, i) {
                        // print(
                        //   '(${widget.data['category']}) page=$_page and total_pages=$_totalPages',
                        // // );
                        if (i == _products.length && _page < _totalPages) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        // if (i == _products.length) {
                        //   return const SeeAllButton();
                        // }

                        if (i <= _products.length - 1) {
                          final product = _products[i];
                          return ProductItem(product);
                        }

                        return null;
                      },
                    ),
                    onNotification: (scrollEnd) {
                      if (scrollEnd.metrics.atEdge &&
                          scrollEnd.metrics.pixels > 0) {
                        if (_page < _totalPages) {
                          _page++;
                          _fetchFirebaseData();
                        }
                      }
                      return true;
                    },
                  ),
                ),
              ],
            )
          : const ProductListLoader(),
    );
  }
}
