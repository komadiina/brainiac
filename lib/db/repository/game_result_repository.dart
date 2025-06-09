import 'package:mozgalica/db/database_singleton.dart';
import 'package:mozgalica/resources/configurations/variables.dart';
import 'package:mozgalica/db/model/game_result.dart';
import 'package:sqflite/sqflite.dart';

class GameResultRepository {
  static Future<void> insert(Database db, GameResult data) async {
    await db.insert(
      databaseTableName,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertAll(Database db, List<GameResult> data) async {
    for (GameResult result in data) {
      insert(db, result);
    }
  }

  static Future<List<GameResult>> getAll(Database db) async {
    final List<Map<String, Object?>> result = await db.query(databaseTableName);
    return result.map(GameResult.fromMap).toList();
  }

  static Future<void> update(Database db, GameResult data) async {
    await db.update(
      databaseTableName,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  static Future<void> delete(Database db, int id) async {
    await db.delete(databaseTableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> saveGameAttempt(
    String username,
    String gameName,
    double score,
  ) async {
    final gameResult = GameResult(
      id: null,
      username: username,
      gameName: gameName,
      score: score,
      dateTime: DateTime.now(),
    );

    var db = await DatabaseSingleton().database;
    insert(db, gameResult);
  }
}
