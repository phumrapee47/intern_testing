import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final now = DateTime.now();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'reading_history.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reading_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id INTEGER,
        title TEXT,
        latitude REAL,
        longitude REAL,
        timestamp TEXT
      )
    ''');
  }

  // Insert ประวัติการอ่าน
  Future<int> insertHistory(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('reading_history', row);
  }

  // ดึงประวัติทั้งหมด เรียงจากล่าสุดไปเก่าสุด
  Future<List<Map<String, dynamic>>> getAllHistory() async {
    Database db = await database;
    return await db.query('reading_history', orderBy: 'timestamp DESC');
  }

  // ลบประวัติทั้งหมด (เผื่อใช้ทดสอบ)
  Future<int> clearHistory() async {
    Database db = await database;
    return await db.delete('reading_history');
  }

  Future<int> deleteHistory(int id) async {
    Database db = await database;
    return await db.delete('reading_history', where: 'id = ?', whereArgs: [id]);
  }

  // Future<int> getHistory(int id) async {
  //   Database db = await database;
  //   return await db.query('reading_history', where: 'id = ?', whereArgs: [id]);
  // }
}
