import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/providers/fire_source_provider.dart';
import 'package:shop_fire/providers/theme_mode_provider.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';
import 'package:shop_fire/screens/cart/cart_screen.dart';
import 'package:shop_fire/screens/favorites/favorites_screen.dart';
import 'package:shop_fire/screens/home/widgets/body.dart';
import 'package:shop_fire/screens/home/widgets/search/custom_search_delegate.dart';

import '../add_product/add_product_screen.dart';

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

final fireAuth = FirebaseAuth.instance;
final user = fireAuth.currentUser;

AppBar _buildAppBar(BuildContext context) {
  print('_buildAppBar() called');
  return AppBar(
    // backgroundColor:
    // ref.read(themeModeProvider.notifier).isDark ? null : Colors.white,
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
            offset: const Offset(-3, 0),
            isLabelVisible: totalCartItems >= 1,
            backgroundColor: Theme.of(context).colorScheme.secondary,
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
            title: const Text('add product'),
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
            title: const Text('cart'),
            onTap: () {
              closeDrawer(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
          ListTile(
            dense: true,
            style: ListTileStyle.drawer,
            leading: const Icon(Icons.favorite_outline),
            title: const Text('favorites'),
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
            leading: const Icon(Icons.exit_to_app),
            title: const Text('log out'),
            onTap: () {
              fireAuth.signOut();
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              ref.watch(themeModeProvider);
              final themeNotifier = ref.read(themeModeProvider.notifier);
              return SwitchListTile.adaptive(
                dense: true,
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('dark mode'),
                value: themeNotifier.isDark,
                onChanged: (v) {
                  ref
                      .read(fireSourcProvider.notifier)
                      .changeSourceToCacheAndRevertAfterAwhile();
                  themeNotifier.toggleMode();
                },
              );
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
