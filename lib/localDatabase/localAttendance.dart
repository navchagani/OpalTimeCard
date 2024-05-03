import 'package:flutter/material.dart';
import 'package:opaltimecard/User/Modal/EmployeeData.dart';
import 'package:opaltimecard/User/Modal/usermodal.dart' as EmployeeDataModel;
import 'package:opaltimecard/localDatabase/createTable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalAttendance {
  static const databaseName = 'attendance';

  static get getPath async => await toPath();

  static Future<String> toPath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$databaseName.db');
    return path;
  }

  Future<void> initialize() async {
    final path = await getPath;

    final employeeModel = const EmployeeDataModel.EmployeeModel().toJson();

    final table = CreateTables.createTable('`$databaseName`', employeeModel);

    await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(table);
    });
  }

  // Future<EmployeeAttendance> addToLocal(
  //     {required BuildContext context,
  //     required EmployeeDataModel.EmployeeModel employeeModel}) async {
  //   final path = await getPath;
  //   final open = await openDatabase(path);

  //   await open.transaction((txn) async {
  //     int id1 = await txn.insert(databaseName, employeeModel.toJson());
  //   });
  // }
}
// import 'package:flutter/material.dart';
// import 'package:opaltimecard/User/Modal/EmployeeData.dart';
// import 'package:opaltimecard/User/Modal/usermodal.dart' as EmployeeDataModel;
// import 'package:opaltimecard/localDatabase/createTable.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class LocalAttendance {
//   static const databaseName = 'attendance.db';

//   static Future<String> get databasePath async {
//     var databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, databaseName);
//     return path;
//   }

//   Future<void> initialize() async {
//     final path = await databasePath;

//     final employeeModel = const EmployeeDataModel.EmployeeModel().toJson();
//     final table = CreateTables.createTable(databaseName, employeeModel);

//     await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute(table);
//     });
//   }

//   Future<EmployeeAttendance> addToLocal({
//     required BuildContext context,
//     required EmployeeDataModel.EmployeeModel employeeModel,
//   }) async {
//     final path = await databasePath;
//     final db = await openDatabase(path);

//     // Assuming EmployeeAttendance can be initialized from EmployeeModel
//     // and an `id` that was inserted to the database.
//     return await db.transaction((txn) async {
//       int id = await txn.insert(databaseName, employeeModel.toJson());
//       // Constructing EmployeeAttendance from the inserted record.
//       // Ensure that EmployeeAttendance has a suitable constructor or factory method.
//       return EmployeeAttendance.fromDatabase(id, employeeModel);
//     });
//   }
// }

// class EmployeeAttendance {
//   final int id;
//   final EmployeeDataModel.EmployeeModel employee;

//   EmployeeAttendance({required this.id, required this.employee});

//   factory EmployeeAttendance.fromDatabase(int id, EmployeeDataModel.EmployeeModel employee) {
//     return EmployeeAttendance(id: id, employee: employee);
//   }
// }
