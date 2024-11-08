import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_project/models/task.dart';

class DbServices {
  static Database? _db;
  static final DbServices instance = DbServices._();

  DbServices._();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();

    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "database_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute("""
          CREATE TABLE tasks ( 
            id INTEGER PRIMARY KEY,
            task_conteudo TEXT NOT NULL,
            task_status INTEGER NOT NULL
          );
        """);
      },
    );

    return database;
  }

  void addTask(
    String content,
  ) async {
    final db = await database;
    await db.insert(
      "tasks",
      {
        "task_conteudo": content,
        "task_status": 0,
      },
    );
  }

  Future<List<Task>?> getTasks() async {
    final db = await database;
    final data = await db.query("tasks");

    List<Task> tasks = data.map((e) => Task.fromMap(e)).toList();

    return tasks.isNotEmpty ? tasks : null;
  }

  void updateTaskStatus(int id, int status) async {
    final db = await database;
    await db.update(
      "tasks",
      {
        "task_status": 1,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  void deleteTask(int id) async {
    final db = await database;
    await db.delete(
      "tasks",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
