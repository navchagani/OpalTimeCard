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
      employee_id INTEGER,
      employee_name TEXT,
      pin TEXT,
      time TEXT,
      date TEXT,
      uid TEXT,
      status TEXT
    )
  ''');
    log('Database table created successfully');
  }

  Future<int> insertAttendance(EmployeeAttendance record) async {
    Database db = await instance.database;
    log("Inserting into database: $record");
    return await db.insert('attendance', record.toJson());
  }

  Future<List<EmployeeAttendance>> getAllAttendanceForEmployee(int int) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('attendance');
    List<EmployeeAttendance> attendanceList = [];
    for (var item in result) {
      attendanceList.add(EmployeeAttendance.fromJson(item));
    }
    log('All attendance records: $attendanceList');
    return attendanceList;
  }

  Future<EmployeeAttendance?> getLastAttendance(String pin) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('attendance',
        where: 'pin = ?', whereArgs: [pin], orderBy: 'id DESC', limit: 1);
    if (result.isNotEmpty) {
      log("Last attendance for pin $pin: ${result.first}");
      return EmployeeAttendance.fromJson(result.first);
    }
    return null;
  }
}
