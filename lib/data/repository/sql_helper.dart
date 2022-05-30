import 'package:flutter/foundation.dart';
import 'package:socmed/data/data_provider/model/FeedItemModel.dart';
import 'package:socmed/data/data_provider/model/StoryItemModel.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createUserTable(sql.Database database) async {
    await database.execute("""CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        email TEXT,
        password TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<void> createFeedItemTable(sql.Database database) async {
    await database.execute("""CREATE TABLE feed_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<void> createStoryTable(sql.Database database) async {
    await database.execute("""CREATE TABLE story_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'socmed.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createUserTable(database);
        await createFeedItemTable(database);
        await createStoryTable(database);
      },
    );
  }

  Future<Future<List<Map<String, Object?>>>> getEmail(String email, String? password) async {
    final db = await SQLHelper.db();
    return db.query('users', where: "email = ?", whereArgs: [email]);

    // final data = {'email': email, 'password': password};
    // final id = await db.insert('user', data,
    //     conflictAlgorithm: sql.ConflictAlgorithm.replace);
    // return id;
  }

  // Create new item (journal)
  static Future<int> registerUser(String email, String? password) async {
    final db = await SQLHelper.db();


    final data = {'email': email, 'password': password};
    final id = await db.insert('user', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createFeedItem(String title, String? descrption) async {
    final db = await SQLHelper.db();


    final data = {'title': title, 'description': descrption};
    final id = await db.insert('feed_items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createStoryItem(String title, String? descrption) async {
    final db = await SQLHelper.db();


    final data = {'title': title, 'description': descrption};
    final id = await db.insert('story_items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  Future<List<FeedItemModel>> getFeedItems() async {
    final db = await SQLHelper.db();

    List<Map> list = await db.rawQuery('SELECT * FROM feed_items');
    List<FeedItemModel> feeds = [];
    for (int i = 0; i < list.length; i++) {
      feeds.add(FeedItemModel(id: list[i]["id"], title: list[i]["title"],
          description: list[i]["description"]));
    }
    return feeds;
  }

  Future<List<StoryItemModel>> getStoryItems() async {
    final db = await SQLHelper.db();

    List<Map> list = await db.rawQuery('SELECT * FROM story_items');
    List<StoryItemModel> feeds = [];
    for (int i = 0; i < list.length; i++) {
      feeds.add(StoryItemModel(id: list[i]["id"], title: list[i]["title"],
          description: list[i]["description"]));
    }
    return feeds;
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}