class EmployeeAttendance {
  final int? employeeId;
  final String? employeeName;
  final String? businessId;
  final String? pin;
  final String? date;
  final String? time;
  final String? uid;
  final String? status;
  final String? currentLocation;
  final String? departmentId;

  const EmployeeAttendance({
    this.businessId,
    this.employeeId,
    this.employeeName,
    this.pin,
    this.date,
    this.time,
    this.uid,
    this.status,
    this.currentLocation,
    this.departmentId,
  });

  EmployeeAttendance copyWith({
    int? employeeId,
    String? businessId,
    String? employeeName,
    String? pin,
    String? date,
    String? time,
    String? uid,
    String? status,
    String? currentLocation,
    String? departmentId,
  }) {
    return EmployeeAttendance(
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      businessId: businessId ?? this.businessId,
      pin: pin ?? this.pin,
      date: date ?? this.date,
      time: time ?? this.time,
      uid: uid ?? this.uid,
      status: status ?? this.status,
      currentLocation: currentLocation ?? this.currentLocation,
      departmentId: departmentId ?? this.departmentId,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'employee_id': employeeId,
      'employee_name': employeeName,
      'business_id': businessId,
      'pin': pin,
      'date': date,
      'time': time,
      'uid': uid,
      'status': status,
      'current_location': currentLocation,
      'department_id': departmentId,
    };
  }

  static EmployeeAttendance fromJson(Map<String, Object?> json) {
    return EmployeeAttendance(
      employeeId:
          json['employee_id'] == null ? null : json['employee_id'] as int,
      employeeName: json['employee_name'] == null
          ? null
          : json['employee_name'] as String,
      businessId:
          json['business_id'] == null ? null : json['business_id'] as String,
      pin: json['pin'] == null ? null : json['pin'] as String,
      date: json['date'] == null ? null : json['date'] as String,
      time: json['time'] == null ? null : json['time'] as String,
      uid: json['uid'] == null ? null : json['uid'] as String,
      status: json['status'] == null ? null : json['status'] as String,
      currentLocation: json['current_location'] == null
          ? null
          : json['current_location'] as String,
      departmentId: json['department_id'] == null
          ? null
          : json['department_id'] as String,
    );
  }

  @override
  String toString() {
    return '''EmployeeAttendance(
      employeeId: $employeeId,
      employeeName: $employeeName,
      businessId: $businessId,
      pin: $pin,
      date: $date,
      time: $time,
      uid: $uid,
      status: $status,
      currentLocation: $currentLocation,
      departmentId: $departmentId,
    )''';
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeAttendance &&
        other.runtimeType == runtimeType &&
        other.employeeId == employeeId &&
        other.employeeName == employeeName &&
        other.businessId == businessId &&
        other.pin == pin &&
        other.date == date &&
        other.time == time &&
        other.uid == uid &&
        other.status == status &&
        other.currentLocation == currentLocation &&
        other.departmentId == departmentId;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      employeeId,
      employeeName,
      businessId,
      pin,
      date,
      time,
      uid,
      status,
      currentLocation,
      departmentId,
    );
  }
}
