import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/constans.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';
import 'package:shop_fire/screens/cart/providers/selecton_provider.dart';
import 'package:shop_fire/screens/cart/widgets/cart_summary.dart';
import 'package:shop_fire/screens/cart/widgets/cart_tile.dart';

import 'models/cart_item.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _listKey = GlobalKey<AnimatedListState>();

  _onCartItemDeleted({required index, CartItem? cartItem}) {
    _listKey.currentState!.removeItem(
      index,
      duration: const Duration(milliseconds: 400),
      (context, animation) {
        if (cartItem != null) {
          return FadeTransition(
            opacity: animation,
            child: AbsorbPointer(
              child: CartTile(
                cartItem: cartItem,
                onCartItemRemoved: () {},
              ),
            ),
          );
        }
        return OverlayPortal(
          controller: OverlayPortalController(),
          overlayChildBuilder: (context) {
            return const Spacer();
          },
        );
      },
    );
  }

  int _getTotalPrice(List<CartItem> cartItem) {
    double sum = 0;
    for (var element in cartItem) {
      sum += element.quantity * element.product.price;
    }
    return sum.toInt();
  }

  // @override
  // void dispose() {
  //   // print('cart_screen disposed');
  //   ref.read(selectionProvider.notifier).deleteAll();
  //   super.dispose();
  // }

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 10)).then((value) {
      ref.read(selectionProvider.notifier).deleteAll();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final selectedItems = ref.read(selectionProvider);
    // print('CartScreen called');

    Widget content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(
                  text: '${'total'.tr()}\n',
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: '\$${_getTotalPrice(cartItems)}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, a1, a2) => Consumer(
                      builder: (context, ref, child) {
                        final cartItems = ref.watch(cartProvider);
                        return CartSummary(
                          cartItems: cartItems,
                          totalPrice: _getTotalPrice(cartItems),
                        );
                      },
                    ),
                  );
                },
                label: const Text('order').tr(),
                icon: const Icon(Icons.add_task),
              ),
            ],
          ),
        ),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: cartItems.length,
            itemBuilder: (context, i, animation) {
              final cartItem = cartItems[i];

              return Dismissible(
                key: ValueKey(cartItems[i].product.id),
                direction: selectedItems.contains(cartItems[i])
                    ? DismissDirection.none
                    : DismissDirection.startToEnd,
                onDismissed: (dir) {
                  ref.read(cartProvider.notifier).deleteCartItem(cartItems[i]);
                  _onCartItemDeleted(index: i);
                },
                child: CartTile(
                  cartItem: cartItem,
                  onCartItemRemoved: () {
                    _onCartItemDeleted(index: i, cartItem: cartItems[i]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );

    if (cartItems.isEmpty) {
      content = AlertDialog(
        title: const Text('oops'),
        // actionsPadding: const EdgeInsets.all(10),
        contentTextStyle: Theme.of(context).textTheme.titleMedium,
        content: const Text('cart is empty right now!'),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('ok'),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart').tr(),
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },

            child: ref.watch(selectionIsNotEmptyProvider)
                ? Row(
                    key: ValueKey<int>(ref.read(selectionLengthProvider)),
                    children: [
                      const Icon(
                        Icons.check,
                        // color: Theme.of(context).colorScheme.secondary,
                      ),
                      Text.rich(
                        TextSpan(
                          text: '${ref.watch(selectionLengthProvider)}',
                          style: const TextStyle(
                              // color: Theme.of(context).colorScheme.secondary,
                              ),
                          children: [
                            TextSpan(
                              text: ' ${'items'.tr()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              padding: const EdgeInsets.all(0),
                              child: ListTile(
                                dense: true,
                                leading: const Icon(Icons.select_all_outlined),
                                title: const Text('select_all').tr(),
                              ),
                              onTap: () {
                                ref.read(selectAllProvider)();
                              },
                            ),
                            PopupMenuItem(
                              padding: const EdgeInsets.all(0),
                              child: ListTile(
                                dense: true,
                                leading: const Icon(
                                    Icons.check_box_outline_blank_outlined),
                                title: const Text('un_select_all').tr(),
                              ),
                              onTap: () {
                                ref
                                    .read(selectionProvider.notifier)
                                    .deleteAll();
                              },
                            ),
                            PopupMenuItem(
                              padding: const EdgeInsets.all(0),
                              child: ListTile(
                                dense: true,
                                leading: const Icon(Icons.delete_outline),
                                title: const Text('delete').tr(),
                              ),
                              onTap: () {
                                handlePopupDeleteTap();
                              },
                            ),
                          ];
                        },
                      ),
                    ],
                  )
                : Container(), // Empty container when no items are selected
          ),
        ],
      ),
      body: content,
    );
  }

  void handlePopupDeleteTap() {
    if (ref.read(selectionProvider).length == ref.read(cartProvider).length) {
      _listKey.currentState!.removeAllItems(
        (context, animation) {
          return OverlayPortal(
            controller: OverlayPortalController(),
            overlayChildBuilder: (context) {
              return const Spacer();
            },
          );
        },
      );
      ref.read(cartProvider.notifier).clearCartItems();
    } else {
      for (var i = 0; i < ref.read(selectionProvider).length; i++) {
        _listKey.currentState!.removeItem(i, (context, animation) {
          return OverlayPortal(
            controller: OverlayPortalController(),
            overlayChildBuilder: (context) {
              return const Spacer();
            },
          );
        });
      }
      ref.read(removeSelectedFromCarProvider)();
    }
  }
}
