import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:shop_fire/screens/home/widgets/product_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../constans.dart';
import '../../../models/product.dart';

class ProductListHorizonScroll extends StatefulWidget {
  const ProductListHorizonScroll(
    this.category, {
    super.key,
  });

  // final Map<String, dynamic> data;

  final String category;

  @override
  State<ProductListHorizonScroll> createState() =>
      _ProductListHorizonScrollState();
}

class _ProductListHorizonScrollState extends State<ProductListHorizonScroll> {
  final ScrollController _scrollController = ScrollController();

  List<Product> _products = [];
  static const PAGE_SIZE = 5;
  bool _allFetched = false;
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;
  int _totalResults = 0;
  int _page = 1;
  int get _totalPages => (_totalResults / PAGE_SIZE).ceil();

  // _scrollListener() {
  //   if (_scrollController.offset >=
  //       _scrollController.position.maxScrollExtent) {
  //     // if (_page == _totalPages) {
  //     //   return;
  //     // }
  //     // _page++;
  //     _fetch();
  //   }
  // }

  // _fetch() async {
  //   // print(widget.count.toString());
  // }

  Future<void> _fetchFirebaseData() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Query _query = FirebaseFirestore.instance
        .collection("products")
        .where('category', isEqualTo: widget.category)
        .orderBy('createdAt');
    if (_lastDocument != null) {
      _query = _query.startAfterDocument(_lastDocument!).limit(PAGE_SIZE);
    } else {
      _query = _query.limit(PAGE_SIZE);
    }

    final List<Product> pagedData = await _query.get().then((value) {
      if (value.docs.isNotEmpty) {
        _lastDocument = value.docs.last;
      } else {
        _lastDocument = null;
      }
      return value.docs
          .map((e) => Product.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });

    setState(() {
      _products.addAll(pagedData);
      if (pagedData.length < PAGE_SIZE) {
        _allFetched = true;
      }
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTotalResults();
    _fetchFirebaseData();
  }

  void _getTotalResults() {
    FirebaseFirestore.instance
        .collection("products")
        .where('category', isEqualTo: widget.category)
        .count()
        .get()
        .then(
          (res) => setState(() {
            _totalResults = res.count;
          }),
          onError: (e) => print("Error completing: $e"),
        );
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
                const SizedBox(height: kDefaultPaddin + 10),
                Text(_products[0].category),
                Text('$_totalResults results'),
                const SizedBox(height: kDefaultPaddin / 2),
                SizedBox(
                  height: 200,
                  // width: 200,
                  child: NotificationListener<ScrollEndNotification>(
                    child: ListView.builder(
                      controller: _scrollController,
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
                      },
                    ),
                    onNotification: (scrollEnd) {
                      if (scrollEnd.metrics.atEdge &&
                          scrollEnd.metrics.pixels > 0) {
                        print('***** $_totalPages');
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
          : Skeletonizer(
              enabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: kDefaultPaddin),
                  Text('mmmmm'),
                  Text('mmm'),
                  SizedBox(height: kDefaultPaddin),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return const Card(
                          child: SizedBox(
                            height: 50,
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(),
                                Text('mmm'),
                                Text('mmmmmmmmm'),
                                Text('mmmmmmmm'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
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
