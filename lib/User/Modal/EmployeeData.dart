class EmployeeAttendance {
  final int? employeeId;
  final String? employeeName;
  final String? pin;
  final String? date;
  final String? time;
  final String? uid;
  final String? status;
  const EmployeeAttendance(
      {this.employeeId,
      this.employeeName,
      this.pin,
      this.date,
      this.time,
      this.uid,
      this.status});
  EmployeeAttendance copyWith(
      {int? employeeId,
      String? employeeName,
      String? pin,
      String? date,
      String? time,
      String? uid,
      String? status}) {
    return EmployeeAttendance(
        employeeId: employeeId ?? this.employeeId,
        employeeName: employeeName ?? this.employeeName,
        pin: pin ?? this.pin,
        date: date ?? this.date,
        time: time ?? this.time,
        uid: uid ?? this.uid,
        status: status ?? this.status);
  }

  Map<String, Object?> toJson() {
    return {
      'employee_id': employeeId,
      'employee_name': employeeName,
      'pin': pin,
      'date': date,
      'time': time,
      'uid': uid,
      'status': status
    };
  }

  static EmployeeAttendance fromJson(Map<String, Object?> json) {
    return EmployeeAttendance(
        employeeId:
            json['employee_id'] == null ? null : json['employee_id'] as int,
        employeeName: json['employee_name'] == null
            ? null
            : json['employee_name'] as String,
        pin: json['pin'] == null ? null : json['pin'] as String,
        date: json['date'] == null ? null : json['date'] as String,
        time: json['time'] == null ? null : json['time'] as String,
        uid: json['uid'] == null ? null : json['uid'] as String,
        status: json['status'] == null ? null : json['status'] as String);
  }

  @override
  String toString() {
    return '''EmployeeAttendance(
                employeeId:$employeeId,
employeeName:$employeeName,
pin:$pin,
date:$date,
time:$time,
uid:$uid,
status:$status
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeAttendance &&
        other.runtimeType == runtimeType &&
        other.employeeId == employeeId &&
        other.employeeName == employeeName &&
        other.pin == pin &&
        other.date == date &&
        other.time == time &&
        other.uid == uid &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, employeeId, employeeName, pin, date, time, uid, status);
  }
}
