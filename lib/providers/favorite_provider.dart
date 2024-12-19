import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../models/product/product.dart';

const createTableSql =
    'CREATE TABLE favorites(id TEXT PRIMARY KEY, title TEXT, description TEXT, category TEXT, imageUrl TEXT, price REAL, createdAt TEXT)';

Future<sql.Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'shop'),
    onCreate: (db, version) {
      return db.execute(createTableSql);
    },
    version: 1,
  );
  return db;
}

class FavoriteNotifier extends StateNotifier<List<Product>> {
  FavoriteNotifier() : super([]);
  toggleFavoriteProduct(Product product) async {
    final db = await _getDataBase();
    if (state.contains(product)) {
      await db.delete('favorites', where: 'id == ?', whereArgs: [product.id]);
      // state = state.where((element) => element != product).toList();
      state = await _fetchedFavorites();
    } else {
      await db.insert('favorites', product.toJson());
      state = [...state, product];
    }
  }

  Future<List<Product>> _fetchedFavorites() async {
    final db = await _getDataBase();
    final docs = await db.query('favorites');
    return docs.map((doc) => Product.fromJson(doc)).toList();
  }

  loadFavoriets() async {
    state = await _fetchedFavorites();
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<Product>>(
  (ref) {
    return FavoriteNotifier();
  },
);
