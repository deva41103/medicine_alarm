import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/medicine_model.dart';

class MedicineDatabase {
  static final MedicineDatabase instance = MedicineDatabase._init();
  static Database? _database;

  MedicineDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('medicines.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dose TEXT NOT NULL,
        hour INTEGER NOT NULL,
        minute INTEGER NOT NULL
      )
    ''');
  }

  /// Insert a new medicine
  Future<int> insertMedicine(Medicine medicine) async {
    final db = await instance.database;
    return await db.insert(
      'medicines',
      medicine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Fetch all medicines sorted by time
  Future<List<Medicine>> getMedicines() async {
    final db = await instance.database;

    final result = await db.query(
      'medicines',
      orderBy: 'hour ASC, minute ASC',
    );

    return result.map((e) => Medicine.fromMap(e)).toList();
  }

  /// Delete a medicine (optional bonus feature)
  Future<int> deleteMedicine(int id) async {
    final db = await instance.database;
    return await db.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Close database (good practice)
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
