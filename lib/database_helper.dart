import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "leading_sys.db";

  // static final table = 'my_table';
  //
  // static final columnId = '_id';
  // static final columnName = 'name';
  // static final columnAge = 'age';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  var databaseFactory = databaseFactoryFfi;
  Directory documentsDirectory;
  String path;
  // print(databaseFactory.databaseExists(path));

  Future<Database> get database async {
    sqfliteFfiInit();

    documentsDirectory = await getApplicationDocumentsDirectory();
    path = join(documentsDirectory.path, _databaseName);
    print('after path: $path');
    if (_database != null) return _database;
    print('after return _database');
    if (await databaseFactory.databaseExists(path)) {
      _database = await databaseFactory.openDatabase(path);
      print('inside if ');
      return _database;
    }
    print('before init');
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    print('initiate database ');
    // _database = await databaseFactory.openDatabase(path);
    _database = await databaseFactory.openDatabase(path);
    print('after open ');
    await _database.execute('''
      CREATE TABLE Target (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        lat REAL,
        lng REAL
      )
    ''');
    print('after Target ');
    await _database.execute('''
      CREATE TABLE My_location (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        lat REAL,
        lng REAL,
        w_type INTEGER,
        deg_start REAL,
        deg_end REAL,
        dis_start REAL,
        dis_end REAL
      )
    ''');
    await _database.execute('''
      CREATE TABLE W_type (
        id INTEGER PRIMARY KEY, 
        name TEXT NOT NULL, 
        using_table TEXT
      )
    ''');
    await _database.execute('''
      CREATE TABLE Using_120 (
        id INTEGER PRIMARY KEY, 
        degree REAl NOT NULL, 
        distance REAl NOT NULL, 
        circles_num INTEGER
      )
    ''');
    //await _database.close();
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(tableName) async {
    Database db = await instance.database;
    //return await db.query(table);
    return await db.query(tableName, orderBy: 'order_index ASC');
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<List<Map<String, dynamic>>> queryRowCount(String table) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT COUNT(*) FROM $table');
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(table, row, where: 'id= ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id= ?', whereArgs: [id]);
  }
}

// Future main() async {
//   // Init ffi loader if needed.
//   sqfliteFfiInit();
//
//   var databaseFactory = databaseFactoryFfi;
//   var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
//   await db.execute('''
//   CREATE TABLE Product (
//       id INTEGER PRIMARY KEY,
//       title TEXT
//   )
//   ''');
//   await db.insert('Product', <String, dynamic>{'title': 'Product 1'});
//   await db.insert('Product', <String, dynamic>{'title': 'Product 1'});
//
//   var result = await db.query('Product');
//   print(result);
//   // prints [{id: 1, title: Product 1}, {id: 2, title: Product 1}]
//   await db.close();
// }
