import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fire/screens/cart/models/cart_item.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';

class SeclectionProvider extends StateNotifier<List<CartItem>> {
  SeclectionProvider() : super([]);
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

final seclectionProvider =
    StateNotifierProvider<SeclectionProvider, List<CartItem>>(
  (ref) => SeclectionProvider(),
);

// final isSelectedProvider = Provider((ref) => ref.watch(seclectionProvider.notifier))

final isSelectionProcessProvider = Provider(
  (ref) => ref.watch(seclectionProvider).isNotEmpty,
);

final removeSelectedFromCarProvider = Provider((ref) {
  return () async {
    final selected = ref.read(seclectionProvider);
    await ref.read(cartProvider.notifier).deleteMany(selected);
    ref.read(seclectionProvider.notifier).deleteAll();
  };
});

final selectAllProvider = Provider((ref) {
  return () {
    final cartItems = ref.read(cartProvider);
    ref.read(seclectionProvider.notifier).insertMany(cartItems);
  };
});

// final selectionLengthProvider = Provider(
//   (ref) => ref.watch(seclectionProvider).length,
// );
