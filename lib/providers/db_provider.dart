import 'dart:io';
import 'package:latin_news/models/news_post.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();

    return _database;
  }


  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'news_post.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE NewsPost('
              'id INTEGER PRIMARY KEY,'
              'userId INTEGER,'
              'title TEXT,'
              'body TEXT)'
              );
        });
  }

  createNews(NewsPost newsPost) async {
    final db = await database;
    final res = await db?.insert('NewsPost', newsPost.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);

    return res;
  }

  Future<int> deleteAllPosts() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM NewsPost');

    if(res != null){
      return res;
    }

    return 0;
  }

  Future<List<NewsPost>> getAllNewsPosts() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM NewsPost");

    List<NewsPost> list =
    res!.isNotEmpty ? res.map((c) => NewsPost.fromJson(c)).toList() : [];

    return list;
  }
}