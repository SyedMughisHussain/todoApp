import 'package:flutter/foundation.dart';
import '../model/task.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtech.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String title, String? description) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': description};
    final id = await db.insert(
      'items',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Task>> getItems() async {
    final db = await SQLHelper.db();
    final results = await db.query('items', orderBy: 'id');
    return results.map((map) => Task.fromMap(map)).toList();
  }

  static Future<Task> getItem(int id) async {
    final db = await SQLHelper.db();
    final result =
        await db.query('items', where: 'id = ?', whereArgs: [id], limit: 1);
    return Task.fromMap(result.first);
  }

  static Future<int> updateItem(
      int id, String title, String? description) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString(),
    };

    final result =
        await db.update('items', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('items', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('Something went wrong when deleting an item: $err');
    }
  }
}
