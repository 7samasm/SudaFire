import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/models/product/product.dart';
import 'package:shop_fire/screens/home/widgets/search/sort_radio_group.dart';
import 'package:shop_fire/widgets/matreial_dialog.dart';
import 'package:shop_fire/widgets/product_card_item/product_item.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({
    super.key,
    required this.query,
  });

  final String query;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

final orderValues = ['desc', 'asc'];

class _SearchResultState extends State<SearchResult> {
  String _sort = 'price';
  String _order = orderValues[0];
  // ignore: prefer_function_declarations_over_variables
  late Stream<QuerySnapshot<Map<String, dynamic>>> searchStreem;
  @override
  void initState() {
    setState(() {
      searchStreem = FirebaseFirestore.instance
          .collection('products')
          .where('title', isGreaterThanOrEqualTo: widget.query)
          .where('title', isLessThanOrEqualTo: '${widget.query}\uf8ff')
          .snapshots();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: searchStreem,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data!.docs;
        if (results.isEmpty) {
          return const Center(
            child: Text('no results found!'),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Row(
                children: [
                  Text(
                    'sort result',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                        ) {
                          return MaterialDialog(
                            title: 'Sort',
                            action: TextButton.icon(
                              onPressed: () {
                                print(_order);
                                print(_sort);
                                setState(
                                  () {
                                    searchStreem = FirebaseFirestore.instance
                                        .collection('products')
                                        .where('title',
                                            isGreaterThanOrEqualTo:
                                                widget.query)
                                        .where('title',
                                            isLessThanOrEqualTo:
                                                '${widget.query}\uf8ff')
                                        .orderBy('title')
                                        .orderBy(_sort,
                                            descending: _order == 'desc')
                                        .snapshots();
                                  },
                                );
                              },
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text('ok'),
                              style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface),
                            ),
                            content: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding,
                                  ),
                                  child: Row(
                                    children: [
                                      const Text('sort by'),
                                      const Spacer(),
                                      DropdownMenu(
                                        width: 120,
                                        inputDecorationTheme:
                                            const InputDecorationTheme(
                                          outlineBorder: BorderSide(
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        initialSelection: _sort,
                                        onSelected: (value) {
                                          _sort = value!;
                                        },
                                        dropdownMenuEntries: const [
                                          DropdownMenuEntry(
                                            value: 'title',
                                            label: 'alphabet',
                                          ),
                                          DropdownMenuEntry(
                                            value: 'price',
                                            label: 'price',
                                          ),
                                          DropdownMenuEntry(
                                            value: 'date',
                                            label: 'date',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: SortRadioGroup(
                                    onChange: (v) {
                                      _order = orderValues[v];
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.sort_outlined),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPadding / 2,
                  crossAxisSpacing: kDefaultPadding / 2,
                  childAspectRatio: 0.9,
                ),
                itemCount: results.length,
                padding: const EdgeInsets.all(kDefaultPadding),
                itemBuilder: (context, index) {
                  final document = results[index];
                  return Card(
                    child: ProductItem(
                      product: Product.fromDocument(document),
                      showCartIcon: false,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
