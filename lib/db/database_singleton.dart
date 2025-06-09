import 'package:mozgalica/resources/configurations/variables.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseSingleton {
  static final DatabaseSingleton _instance = DatabaseSingleton._internal();
  static Database? _db;
  static final Lock _lock = Lock();

  DatabaseSingleton._internal();

  factory DatabaseSingleton() => _instance;

  Future<Database> get database async {
    if (_db != null) return _db!;

    await _lock.synchronized(() async {
      _db ??= await _initDatabase();
    });

    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);

    // dev
    // await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE game_result (
            id INTEGER PRIMARY KEY,
            username TEXT NOT NULL,
            gameName TEXT NOT NULL,
            score DECIMAL(5,2) NOT NULL DEFAULT 0.00,
            dateTime DATETIME DEFAULT CURRENT_TIMESTAMP
          )
          ''',
        );
      },
    );
  }
}
