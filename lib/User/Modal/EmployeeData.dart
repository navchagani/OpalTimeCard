class EmployeeAttendance {
  final String? employeename;
  final String? perhourrate;
  final String? In;
  final String? out;
  final String? difference;
  const EmployeeAttendance(
      {this.employeename,
      this.perhourrate,
      this.In,
      this.out,
      this.difference});
  EmployeeAttendance copyWith(
      {String? employeename,
      String? perhourrate,
      String? In,
      String? out,
      String? difference}) {
    return EmployeeAttendance(
        employeename: employeename ?? this.employeename,
        perhourrate: perhourrate ?? this.perhourrate,
        In: In ?? this.In,
        out: out ?? this.out,
        difference: difference ?? this.difference);
  }

  Map<String, Object?> toJson() {
    return {
      'employeename': employeename,
      'perhourrate': perhourrate,
      'in': In,
      'out': out,
      'difference': difference
    };
  }

  static EmployeeAttendance fromJson(Map<String, Object?> json) {
    return EmployeeAttendance(
        employeename: json['employeename'] == null
            ? null
            : json['employeename'] as String,
        perhourrate:
            json['perhourrate'] == null ? null : json['perhourrate'] as String,
        In: json['in'] == null ? null : json['in'] as String,
        out: json['out'] == null ? null : json['out'] as String,
        difference:
            json['difference'] == null ? null : json['difference'] as String);
  }

  @override
  String toString() {
    return '''EmployeeAttendance(
                employeename:$employeename,
perhourrate:$perhourrate,
in:$In,
out:$out,
difference:$difference
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeAttendance &&
        other.runtimeType == runtimeType &&
        other.employeename == employeename &&
        other.perhourrate == perhourrate &&
        other.In == In &&
        other.out == out &&
        other.difference == difference;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, employeename, perhourrate, In, out, difference);
  }
}
