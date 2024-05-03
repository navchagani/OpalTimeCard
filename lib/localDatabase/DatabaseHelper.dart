import 'dart:developer';

import 'package:opaltimecard/User/Modal/EmployeeData.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'attendance_database.db');
    log('Database path: $path');
    try {
      Database db = await openDatabase(path, version: 1, onCreate: _createDb);
      log('Database opened successfully');
      return db;
    } catch (e) {
      log('Error opening database: $e');
      throw 'Error opening database: $e';
    }
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE attendance(
    id INTEGER PRIMARY KEY,
    employeename TEXT,
    pin TEXT,
    perhourrate TEXT,
    checkIn TEXT,
    checkOut TEXT,
    difference TEXT,
    status TEXT 
)
    ''');
  }

  Future<int> insertAttendance(EmployeeAttendance record) async {
    Database db = await instance.database;
    log("local database:$record");
    return await db.insert('attendance', record.toJson());
  }
}
