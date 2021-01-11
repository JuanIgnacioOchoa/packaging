import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:top_express/states/client.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if(_database != null)
      return _database;
    
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'topexpress.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE clients (
            username TEXT PRIMARY KEY, password TEXT
          )
        ''');
      },
      version: 1
    );
  }

  newClient(Client newClient) async {
    final db = await database;
    await deleteClient();
    var res = await db.rawInsert('''
      INSERT INTO clients (
        username, password
      ) VALUES (?, ?)
    ''', [newClient.username, newClient.password]);

    return res;
  }

  deleteClient() async {
    final db = await database;
    db.rawInsert('''
      DELETE FROM clients
    ''');
  }

  Future<dynamic> getClient() async {
    final db = await database;

    var res = await db.query("clients");

    if(res.length == 0) {
      return null;
    } else {
      var resMap = res[0];
      return resMap.isNotEmpty ? resMap : Null;
    }
  }
}