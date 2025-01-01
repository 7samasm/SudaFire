import 'package:easy_localization/easy_localization.dart';
// import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';
import 'package:shop_fire/screens/cart/cart_screen.dart';
import 'package:shop_fire/screens/home/widgets/body.dart';
import 'package:shop_fire/screens/home/widgets/custom_drawer.dart';
import 'package:shop_fire/screens/home/widgets/search/custom_search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const CustomDrawer(),
      body: const Body(),
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  print('_buildAppBar() called');
  return AppBar(
    elevation: 0,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          showSearch(context: context, delegate: CustomSearchDelegate());
        },
      ),
      Consumer(
        builder: (context, ref, child) {
          print('Consumer builder called for cart icon in the app bar');
          final totalCartItems = ref.watch(cartLengthProvider);
          return Badge.count(
            count: totalCartItems,
            offset: context.locale.languageCode == 'ar'
                ? const Offset(2, 0)
                : const Offset(-3, 0),
            isLabelVisible: totalCartItems >= 1,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: false,
                    builder: (ctx) => const CartScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          );
        },
      ),
    ],
  );
}
