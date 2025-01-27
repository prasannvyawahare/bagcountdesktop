import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../SQLite/database_helper.dart';
import '../model/product.dart';

class ProductRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Create a new product
  Future<int> insertProduct(Product product) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'Product',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all products
  Future<List<Product>> getAllProducts() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Product');

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Get a product by ID
  Future<Product?> getProductById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Product',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  // Update a product
  Future<int> updateProduct(Product product) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Product',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Delete a product
  Future<int> deleteProduct(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Product',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
