import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/providers/fire_source_provider.dart';

import 'package:shop_fire/widgets/product_card_item/product_item.dart';
import 'package:shop_fire/widgets/product_list_horizon_scroll/product_list_loader.dart';

import '../../constans.dart';
import '../../models/product/product.dart';

class ProductListHorizontalScroll extends ConsumerStatefulWidget {
  const ProductListHorizontalScroll({
    required this.category,
    required this.title,
    this.pageTitle = '',
    super.key,
  });

  // final Map<String, dynamic> data;

  final String category;
  final String title;
  final String pageTitle;

  @override
  ConsumerState<ProductListHorizontalScroll> createState() =>
      _ProductListHorizontalScrollState();
}

class _ProductListHorizontalScrollState
    extends ConsumerState<ProductListHorizontalScroll> {
  final List<Product> _products = [];
  static const kPageSize = 6;
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;
  int _totalResults = 0;
  int _page = 1;
  int get _totalPages => (_totalResults / kPageSize).ceil();

  Future<void> _fetchFirebaseData() async {
    if (_isLoading) {
      return;
    }
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      //query
      Query query = FirebaseFirestore.instance
          .collection("products")
          .where('category', isEqualTo: widget.category)
          .orderBy('createdAt', descending: true);
      if (widget.title == 'related' || widget.title == 'see also') {
        query = FirebaseFirestore.instance
            .collection("products")
            .where('title', isNotEqualTo: widget.pageTitle)
            .where('category', isEqualTo: widget.category);
      }
      // get total count before limit  from query above
      var count =
          await query.get(GetOptions(source: ref.read(fireSourcProvider)));
      _totalResults = count.size;
      // if (mounted) {
      //   setState(() {
      //     _totalResults = count.size;
      //   });
      // }
      // get first result or next page depending on last doc exitence
      query = _lastDocument != null
          ? query.startAfterDocument(_lastDocument!).limit(kPageSize)
          : query.limit(kPageSize);
      final value =
          await query.get(GetOptions(source: ref.read(fireSourcProvider)));

      // get last doc if fetched result not empty
      _lastDocument = value.docs.isNotEmpty ? value.docs.last : null;

      // print(_lastDocument!.data());

      final List<Product> fetchedProducts =
          value.docs.map((doc) => Product.fromDocument(doc)).toList();
      if (mounted) {
        setState(
          () {
            _products.addAll(fetchedProducts);
            _isLoading = false;
          },
        );
      }
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      // print(e);
    }
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
      padding: context.locale.languageCode == 'ar'
          ? const EdgeInsets.only(right: kDefaultPadding)
          : const EdgeInsets.only(left: kDefaultPadding),
      child: _products.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.75),
                      ),
                ),
                // Text.rich(
                //   TextSpan(
                //     children: [
                //       TextSpan(
                //         text: '$_totalResults ',
                //         style: Theme.of(context)
                //             .textTheme
                //             .titleMedium!
                //             .copyWith(fontWeight: FontWeight.bold),
                //       ),
                //       TextSpan(
                //         text: 'results'.tr(),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 220,
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
                          return ProductItem(
                            product: product,
                            showHero: true,
                          );
                        }

                        return null;
                      },
                    ),
                    onNotification: (scrollEnd) {
                      if (scrollEnd.metrics.atEdge &&
                          scrollEnd.metrics.pixels > 0) {
                        // print('$_page || $_totalPages');
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
