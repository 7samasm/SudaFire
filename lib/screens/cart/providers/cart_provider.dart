import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:shop_fire/screens/cart/models/cart_item.dart';
import 'package:shop_fire/models/product/product.dart';

Future<sql.Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'shop'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE cart_items(id TEXT PRIMARY KEY, title TEXT, description TEXT, category TEXT, imageUrl TEXT, price REAL, createdAt TEXT, quantity INT)',
      );
    },
    version: 1,
  );
  return db;
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addCartItem(Product product) async {
    final indexOfCartItem =
        state.indexWhere((stateEl) => stateEl.product == product);
    if (indexOfCartItem > -1) {
      updateQuantity(product: product);
    } else {
      final cartItem = CartItem(product: product);
      var items = [...state, cartItem];
      final db = await _getDataBase();
      // await db.execute('DROP TABLE cart_items');
      db.insert(
        'cart_items',
        {...cartItem.product.toJson(), 'quantity': cartItem.quantity},
      );
      state = items;
    }
  }

  void updateQuantity({
    required product,
    int amount = 1,
    bool isAddstion = true,
  }) async {
    final db = await _getDataBase();
    var updatedItem = state.map(
      (stateEl) {
        var qty = stateEl.quantity + amount;
        if (!isAddstion) {
          qty = stateEl.quantity - amount;
        }
        if (stateEl.product == product) {
          db.update('cart_items', {'quantity': qty},
              where: 'id == ?', whereArgs: [product.id]);
          return CartItem(product: product, quantity: qty);
        }
        return stateEl;
      },
    ).toList();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('cart-items', json.encode(updatedItem));

    state = updatedItem;
  }

  void deleteCartItem(CartItem cartItem) async {
    var filteredItems = state.where((stateEl) => stateEl != cartItem).toList();
    final db = await _getDataBase();
    db.delete(
      'cart_items',
      where: 'id == ?',
      whereArgs: [cartItem.product.id],
    );
    state = filteredItems;
  }

  void loadCartItems() async {
    print('loadCartItems() called');

    final db = await _getDataBase();
    // db.execute('DROP TABLE cart_items');
    // ignore: unnecessary_cast
    final cartItems = await db.query('cart_items') as List<dynamic>;
    if (cartItems.isEmpty) {
      state = [];
      return;
    }
    final decodedItems = (cartItems).map(
      (row) => CartItem(
        product: Product(
          id: row['id'],
          title: row['title'],
          description: row['description'],
          category: row['category'],
          imageUrl: row['imageUrl'],
          price: row['price'],
          createdAt: row['createdAt'],
        ),
        quantity: row['quantity'],
      ),
    );
    state = decodedItems.toList();
  }

  void clearCartItems() async {
    final db = await _getDataBase();
    db.delete('cart_items');
    state = [];
  }

  deleteMany(List<CartItem> items) async {
    final db = await _getDataBase();
    for (var item in items) {
      db.delete(
        'cart_items',
        where: 'id == ?',
        whereArgs: [item.product.id],
      );
    }
    state = state.where((element) => !items.contains(element)).toList();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

final cartLengthProvider = Provider((ref) => ref.watch(cartProvider).length);
