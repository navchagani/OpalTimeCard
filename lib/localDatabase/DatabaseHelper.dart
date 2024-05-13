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
      Database db = await openDatabase(path, version: 1, onCreate: _createDb);
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
      employee_name TEXT,
      pin TEXT,
      time TEXT,
      date TEXT,
      uid TEXT,
      status TEXT
    )
  ''');
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
          'empid': data.employeeId.toString(),
          'date': data.date,
          'time': data.time,
          'status': data.status,
          'uid': data.uid
        });

        if (response.statusCode == 200) {
          // await deleteAttendance(data.employeeId!);
        } else {}
      }
    } catch (e) {}
  }
}
