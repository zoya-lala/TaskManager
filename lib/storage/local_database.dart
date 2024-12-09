import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase.internal();
  factory LocalDatabase() => instance;
  LocalDatabase.internal();
  Database? _dbInstance;
  Future<Database> get database async {
    if (_dbInstance != null) return _dbInstance!;
    _dbInstance = await _initDatabase();
    return _dbInstance!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            status TEXT,
            isSynced INTEGER
          )
          ''',
        );
      },
    );
  }

  Future<void> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    await db!.insert(
      'tasks',
      task,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return db!.query('tasks');
  }

  Future<void> updateTask(Map<String, dynamic> task) async {
    final db = await database;
    await db!.update(
      'tasks',
      task,
      where: 'id = ?',
      whereArgs: [task['id']],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getUnsyncedTasks() async {
    final db = await database;
    return db!.query(
      'tasks',
      where: 'isSynced = 0',
    );
  }
}
