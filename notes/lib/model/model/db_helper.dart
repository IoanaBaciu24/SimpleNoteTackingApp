import 'dart:async';
import 'dart:core';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'test1Obj.dart';

class db_helper{

  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'test2';
  static const String DB_NAME = 'newDB.db';

  Future<Database> get db async{
    if(_db!=null)
      {
        return _db;
      }
    _db = await initDB();
    return _db;
  }

  initDB() async{

      io.Directory docDir = await getApplicationDocumentsDirectory();
      String path = join(docDir.path, DB_NAME);
      var db = await openDatabase(path, version: 1, onCreate: _onCreate);
      return db;
  }

  _onCreate(Database db, int version) async {

    await db.execute("create table $TABLE($ID integer primary key , $NAME text)");

  }

  Future<test1Obj> save(test1Obj test1obj) async
  {
    var dbclient = await db;
    test1obj.id = await dbclient.insert(TABLE, test1obj.toMap());

    return test1obj;
  }

  Future<List<test1Obj>> getAll() async{
    var dbclient = await db;
    List<Map> maps = await dbclient.query(TABLE, columns: [ID, NAME]);
    List<test1Obj> boyes = [];
    if(maps.length > 0)
      {
        for (int i=0;i<maps.length;i++)
          {
            boyes.add(test1Obj.fromMap(maps[i]));
          }
      }

    return boyes;
  }


  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(test1Obj employee) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, employee.toMap(),
        where: '$ID = ?', whereArgs: [employee.id]);
  }

  Future close() async{
    var dbclient = await db;
    dbclient.close();
  }


}