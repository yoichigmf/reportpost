import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/workspace.dart';
import '../models/post.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  static final _tableName = "WS1";
  static final _posttableName = "post1";

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // DBがなかったら作る
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // import 'package:path/path.dart'; が必要
    // なぜか サジェスチョンが出てこない
    String path = join(documentsDirectory.path, "ReportDB3.db");

    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {

    // sqliteではDate型は直接保存できないため、文字列形式で保存する
    await db.execute(
        "CREATE TABLE $_posttableName ("
            "id TEXT PRIMARY KEY,"
            "wid TEXT,"
            "postDate TEXT,"
            "note TEXT, "
            "image TEXT, "
            "pflag int, "
            "kind int, "
            "lat NUMERIC, "
            "lon NUMERIC "
            ")"
    );

    return await db.execute(
        "CREATE TABLE $_tableName ("
            "id TEXT PRIMARY KEY,"
            "title TEXT,"
            "dueDate TEXT,"
            "note TEXT, "
            "url TEXT, "
            "username TEXT, "
            "passwd TEXT "
            ")"
    );
  }


  createPost(Postd post) async {
    final db = await database;
    var res = await db.insert(_posttableName, post.toMap());
    print( res);
    return res;
  }


  getAllPost() async {
    final db = await database;
    var res = await db.query(_posttableName);
    List<Postd> list =
    res.isNotEmpty ? res.map((c) => Postd.fromMap(c)).toList() : [];
    return list;
  }

//   read post belog specified Workspace
  getPostinWS( String wsid ) async {
    final db = await database;
    var res = await db.query(_posttableName, where: "wid = ?", whereArgs:[wsid] );
    List<Postd> list =
    res.isNotEmpty ? res.map((c) => Postd.fromMap(c)).toList() : [];
   // res.isNotEmpty ? res.map((c) => Postd.fromMap(c)).toList() : [];
    return list;
  }

  updatePost(Postd rep) async {
    final db = await database;
    var res  = await db.update(
        _posttableName,
        rep.toMap(),
        where: "id = ?",
        whereArgs: [rep.id]
    );
    return res;
  }

  deletePost(String id) async {
    final db = await database;
    var res = db.delete(
        _posttableName,
        where: "id = ?",
        whereArgs: [id]
    );
    return res;
  }

  deletePostInWs(String wid) async {
    final db = await database;
    var res = db.delete(
        _posttableName,
        where: "wid = ?",
        whereArgs: [wid]
    );
    return res;
  }


  createWs(WorkSpace rep) async {
    final db = await database;
    var res = await db.insert(_tableName, rep.toMap());
    return res;
  }

  getAllWs() async {
    final db = await database;
    var res = await db.query(_tableName);
    List<WorkSpace> list =
    res.isNotEmpty ? res.map((c) => WorkSpace.fromMap(c)).toList() : [];
    return list;
  }

  updateWs(WorkSpace rep) async {
    final db = await database;
    var res  = await db.update(
        _tableName,
        rep.toMap(),
        where: "id = ?",
        whereArgs: [rep.id]
    );
    return res;
  }

  deleteWs(String id) async {
    final db = await database;
    var res = db.delete(
        _tableName,
        where: "id = ?",
        whereArgs: [id]
    );
    return res;
  }

}