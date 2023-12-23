import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';
import 'package:shop_fire/screens/cart/cart_screen.dart';
import 'package:shop_fire/screens/home/widgets/body.dart';

import '../../constans.dart';
import '../add_product/add_product_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = ref.watch(cartProvider).length;
    return Scaffold(
      appBar: buildAppBar(context, totalItems),
      drawer: buildDrawer(context),
      body: const Body(),
    );
  }
}

AppBar buildAppBar(BuildContext ctx, int totalItems) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    actions: <Widget>[
      Badge.count(
        count: totalItems,
        offset: const Offset(-3, 0),
        isLabelVisible: totalItems >= 1,
        child: IconButton(
          onPressed: () {
            Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (ctx) => const CartScreen(),
              ),
            );
          },
          icon: const Icon(Icons.shopping_cart_outlined),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {},
      ),
      // IconButton(
      //   icon: Icon(Icons.shopping_cart_outlined),
      //   onPressed: () {},
      // ),
      const SizedBox(width: kDefaultPaddin / 2)
    ],
  );
}

final fireAuth = FirebaseAuth.instance;
final user = fireAuth.currentUser;

Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          padding: const EdgeInsets.all(0),
          child: UserAccountsDrawerHeader(
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
          leading: const Icon(Icons.shopping_cart_outlined),
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
