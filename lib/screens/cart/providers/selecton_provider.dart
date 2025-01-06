import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/screens/cart/models/cart_item.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';

class SelectionProvider extends StateNotifier<List<CartItem>> {
  SelectionProvider() : super([]);
  toggle(CartItem item) {
    if (state.contains(item)) {
      state = state.where((element) => element != item).toList();
    } else {
      state = [...state, item];
    }
  }

  deleteAll() {
    state = [];
  }

  insertMany(List<CartItem> items) {
    state = items;
  }
}

final selectionProvider =
    StateNotifierProvider<SelectionProvider, List<CartItem>>(
  (ref) => SelectionProvider(),
);

// final isSelectedProvider = Provider((ref) => ref.watch(selectionProvider.notifier))

final selectionIsNotEmptyProvider = Provider(
  (ref) => ref.watch(selectionProvider).isNotEmpty,
);

final removeSelectedFromCarProvider = Provider((ref) {
  return () async {
    final selected = ref.read(selectionProvider);
    await ref.read(cartProvider.notifier).deleteMany(selected);
    ref.read(selectionProvider.notifier).deleteAll();
  };
});

final selectAllProvider = Provider((ref) {
  return () {
    final cartItems = ref.read(cartProvider);
    ref.read(selectionProvider.notifier).insertMany(cartItems);
  };
});

final selectionLengthProvider = Provider(
  (ref) => ref.watch(selectionProvider).length,
);
