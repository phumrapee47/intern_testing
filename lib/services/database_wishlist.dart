import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseWishlist {
  static final DatabaseWishlist _instance = DatabaseWishlist._internal();
  static Database? _database;

  factory DatabaseWishlist() => _instance;

  DatabaseWishlist._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'wishlist.db');
    return await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE wishlist ADD COLUMN title TEXT');
      await db.execute('ALTER TABLE wishlist ADD COLUMN body TEXT');
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE wishlist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id INTEGER,
        title TEXT,
        body TEXT,
        timestamp TEXT
      )
    ''');
  }

  // Insert ประวัติการอ่าน
  Future<int> insertWishlist(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('wishlist', row);
  }

  // ดึงประวัติทั้งหมด เรียงจากล่าสุดไปเก่าสุด
  Future<List<Map<String, dynamic>>> getAllWishlist() async {
    Database db = await database;
    return await db.query('wishlist', orderBy: 'timestamp DESC');
  }

  // ลบประวัติทั้งหมด (เผื่อใช้ทดสอบ)
  Future<int> clearWishlist() async {
    Database db = await database;
    return await db.delete('wishlist');
  }

  Future<int> deleteWishlist(int id) async {
    Database db = await database;
    return await db.delete('wishlist', where: 'id = ?', whereArgs: [id]);
  }
}