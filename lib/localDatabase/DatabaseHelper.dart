import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:opaltimecard/User/Modal/EmployeeData.dart';

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
    try {
      Database db = await openDatabase(path,
          version: 3, onCreate: _createDb, onUpgrade: _upgradeDb);
      return db;
    } catch (e) {
      throw 'Error opening database: $e';
    }
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE attendance(
        id INTEGER PRIMARY KEY,
        employee_id INTEGER,
        business_id TEXT,
        employee_name TEXT,
        location TEXT,
        pin TEXT,
        time TEXT,
        date TEXT,
        uid TEXT,
        status TEXT,
        current_location TEXT,
        department_id TEXT,
        device_id TEXT
      )
    ''');
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE attendance ADD COLUMN businessId TEXT
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE attendance ADD COLUMN current_location TEXT
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('''
        ALTER TABLE attendance ADD COLUMN department_id TEXT
      ''');
    }
    if (oldVersion < 5) {
      await db.execute('''
        ALTER TABLE attendance ADD COLUMN device_id TEXT
      ''');
    }
  }

  Future<int> insertAttendance(EmployeeAttendance record) async {
    Database db = await instance.database;
    return await db.insert('attendance', record.toJson());
  }

  Future<List<EmployeeAttendance>> getAllAttendance() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('attendance');
    List<EmployeeAttendance> attendanceList = [];
    for (var item in result) {
      attendanceList.add(EmployeeAttendance.fromJson(item));
    }
    return attendanceList;
  }

  Future<EmployeeAttendance?> getLastAttendance(String pin) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('attendance',
        where: 'pin = ?', whereArgs: [pin], orderBy: 'id DESC', limit: 1);
    if (result.isNotEmpty) {
      return EmployeeAttendance.fromJson(result.first);
    }
    return null;
  }

  Future<List<EmployeeAttendance>> getAllAttendanceRecord() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('attendance');
    return result.map((e) => EmployeeAttendance.fromJson(e)).toList();
  }

  Future<void> deleteAllRecords() async {
    Database db = await instance.database;
    await db.delete('attendance');
  }

  Future<void> deleteAttendance(int id) async {
    Database db = await instance.database;
    await db.delete('attendance', where: 'employee_id = ?', whereArgs: [id]);
  }

  Future<void> postDataToAPI(List<EmployeeAttendance> dataList) async {
    try {
      var url = Uri.parse('https://opaltimecard.com/api/markofflineattandence');

      for (var data in dataList) {
        var response = await http.post(url, body: {
          'pin': data.pin,
          'business_id': data.businessId,
          'empid': data.employeeId.toString(),
          'date': data.date,
          'time': data.time,
          'status': data.status,
          'uid': data.uid,
          'current_location': data.currentLocation,
          'department_id': data.departmentId,
          'device_id': data.deviceId,
        });

        if (response.statusCode == 200) {
          log('Data posted successfully: ${data.toString()}');
        } else {
          log('Failed to post data: ${response.body}');
        }
      }
    } catch (e) {
      log('Error posting data: $e');
    }
  }

  Future<void> postSingleDataToAPI(EmployeeAttendance data) async {
    try {
      var url = Uri.parse('https://opaltimecard.com/api/markofflineattandence');

      var response = await http.post(url, body: {
        'pin': data.pin,
        'business_id': data.businessId,
        'empid': data.employeeId.toString(),
        'date': data.date,
        'time': data.time,
        'status': data.status,
        'uid': data.uid,
        'current_location': data.currentLocation,
        'department_id': data.departmentId,
        'device_id': data.deviceId,
      });
      if (response.statusCode == 200) {
        log('Data posted successfully: ${data.toString()} ${response.body}');
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == "true" &&
            responseBody['success'] == 'You are already ') {
          Database db = await instance.database;

          if (data.status == "out") {
            List<Map<String, dynamic>> inRecords = await db.query('attendance',
                where: 'employee_id = ? AND status = ?',
                whereArgs: [data.employeeId, 'in'],
                orderBy: 'id DESC',
                limit: 1);

            if (inRecords.isNotEmpty) {
              var inRecord = EmployeeAttendance.fromJson(inRecords.first);
              log('Found matching "in" record: $inRecord');
              await db.delete('attendance',
                  where: 'employee_id = ?', whereArgs: [inRecord.employeeId]);
              await db.delete('attendance',
                  where: 'employee_id = ?', whereArgs: [data.employeeId]);

              log('Deleted matching "in" and "out" records for employeeId: ${data.employeeId}');
            } else {
              log('No matching "in" record found for "out" record: $data');
            }
          } else {
            log('Received "in" record, no deletion needed.');
          }
        } else {
          log('API response success is false: ${response.body}');
        }
      } else {
        log('Failed to post data: ${response.body}');
      }
    } catch (e) {
      log('Error posting data: $e');
    }
  }
}
