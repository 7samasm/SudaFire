import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/screens/add_product/add_product_screen.dart';
import 'package:shop_fire/screens/cart/cart_screen.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';
import 'package:shop_fire/screens/favorites/favorites_screen.dart';
import 'package:shop_fire/screens/settings/settings_screen.dart';

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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              margin: const EdgeInsets.only(bottom: 0),
              accountName: Text(user?.displayName ?? 'null'),
              accountEmail: Text('${user?.email}'),
              currentAccountPicture: const CircleAvatar(
                child: FlutterLogo(
                  size: 42,
                ),
              ),
            ),
          ),
          ListTile(
            dense: true,
            style: ListTileStyle.drawer,
            leading: const Icon(Icons.add),
            title: const Text('add product').tr(),
            onTap: () {
              closeDrawer(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              );
            },
          ),
          ListTile(
            dense: true,
            style: ListTileStyle.drawer,
            leading: Consumer(
              builder: (context, ref, child) {
                final totalCartItems = ref.watch(cartLengthProvider);
                return Badge.count(
                  count: totalCartItems,
                  offset: const Offset(10, -10),
                  isLabelVisible: totalCartItems >= 1,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            title: const Text('cart').tr(),
            onTap: () {
              closeDrawer(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  maintainState: false,
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
          ListTile(
            dense: true,
            style: ListTileStyle.drawer,
            leading: const Icon(Icons.favorite_outline),
            title: const Text('favorites').tr(),
            onTap: () {
              closeDrawer(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
          ListTile(
            dense: true,
            style: ListTileStyle.drawer,
            leading: const Icon(Icons.settings_outlined),
            title: const Text('settings').tr(),
            onTap: () {
              closeDrawer(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  maintainState: false,
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            dense: true,
            style: ListTileStyle.drawer,
            leading: const Icon(Icons.exit_to_app),
            title: const Text('log out').tr(),
            onTap: () {
              fireAuth.signOut();
            },
          ),
        ],
      ),
    );
  }

  void closeDrawer(BuildContext context) {
    Navigator.pop(context);
  }
}
