import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';
import 'package:shop_fire/screens/cart/cart_screen.dart';
import 'package:shop_fire/screens/home/widgets/body.dart';
import 'package:shop_fire/screens/home/widgets/custom_searsh_delegate.dart';

import '../add_product/add_product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('HomeScreen called');

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
    backgroundColor: Colors.white,
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
          // ref.read(cartProvider.notifier).loadCartItems();
          final totalCartItems = ref.watch(cartProvider).length;
          return Badge.count(
            count: totalCartItems,
            offset: const Offset(-3, 0),
            isLabelVisible: totalCartItems >= 1,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
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

final fireAuth = FirebaseAuth.instance;
final user = fireAuth.currentUser;

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // print('CustomDrawer called');
    // print(Router(routerDelegate: routerDelegate));
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            child: UserAccountsDrawerHeader(
              margin: const EdgeInsets.only(bottom: 0),
              accountName: const Text('later'),
              accountEmail: Text('${user!.email}'),
              currentAccountPicture: const CircleAvatar(
                child: FlutterLogo(
                  size: 42,
                ),
              ),
            ),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.add),
            title: const Text('add product'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Consumer(
              builder: (context, ref, child) {
                final totalCartItems = ref.watch(cartProvider).length;
                return Badge.count(
                  count: totalCartItems,
                  offset: const Offset(10, -10),
                  isLabelVisible: totalCartItems >= 1,
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            title: const Text('cart'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.exit_to_app),
            title: const Text('log out'),
            onTap: () {
              fireAuth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
