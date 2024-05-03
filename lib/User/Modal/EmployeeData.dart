class EmployeeAttendance {
  final String? employeename;
  final String? pin;
  final String? perhourrate;
  final String? checkIn;
  final String? checkOut;
  final String? difference;
  final String? status;
  const EmployeeAttendance(
      {this.employeename,
      this.pin,
      this.perhourrate,
      this.checkIn,
      this.checkOut,
      this.difference,
      this.status});
  EmployeeAttendance copyWith(
      {String? employeename,
      String? pin,
      String? perhourrate,
      String? checkIn,
      String? checkOut,
      String? difference,
      String? status}) {
    return EmployeeAttendance(
        employeename: employeename ?? this.employeename,
        pin: pin ?? this.pin,
        perhourrate: perhourrate ?? this.perhourrate,
        checkIn: checkIn ?? this.checkIn,
        checkOut: checkOut ?? this.checkOut,
        difference: difference ?? this.difference,
        status: status ?? this.status);
  }

  Map<String, Object?> toJson() {
    return {
      'employeename': employeename,
      'pin': pin,
      'perhourrate': perhourrate,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'difference': difference,
      'status': status
    };
  }

  static EmployeeAttendance fromJson(Map<String, Object?> json) {
    return EmployeeAttendance(
        employeename: json['employeename'] == null
            ? null
            : json['employeename'] as String,
        pin: json['pin'] == null ? null : json['pin'] as String,
        perhourrate:
            json['perhourrate'] == null ? null : json['perhourrate'] as String,
        checkIn: json['checkIn'] == null ? null : json['checkIn'] as String,
        checkOut: json['checkOut'] == null ? null : json['checkOut'] as String,
        difference:
            json['difference'] == null ? null : json['difference'] as String,
        status: json['status'] == null ? null : json['status'] as String);
  }

  @override
  String toString() {
    return '''EmployeeAttendance(
                employeename:$employeename,
pin:$pin,
perhourrate:$perhourrate,
checkIn:$checkIn,
checkOut:$checkOut,
difference:$difference,
status:$status
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeAttendance &&
        other.runtimeType == runtimeType &&
        other.employeename == employeename &&
        other.pin == pin &&
        other.perhourrate == perhourrate &&
        other.checkIn == checkIn &&
        other.checkOut == checkOut &&
        other.difference == difference &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, employeename, pin, perhourrate, checkIn,
        checkOut, difference, status);
  }
}
