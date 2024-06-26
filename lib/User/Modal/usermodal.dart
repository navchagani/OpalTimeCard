// ignore_for_file: non_constant_identifier_names

class EmployeeModel {
  final String? employeename;
  final String? pin;
  final String? perhourrate;
  final String? In;
  final String? out;
  final String? difference;
  const EmployeeModel(
      {this.employeename,
      this.pin,
      this.perhourrate,
      this.In,
      this.out,
      this.difference});
  EmployeeModel copyWith(
      {String? employeename,
      String? pin,
      String? perhourrate,
      String? In,
      String? out,
      String? difference}) {
    return EmployeeModel(
        employeename: employeename ?? this.employeename,
        pin: pin ?? this.pin,
        perhourrate: perhourrate ?? this.perhourrate,
        In: In ?? this.In,
        out: out ?? this.out,
        difference: difference ?? this.difference);
  }

  Map<String, Object?> toJson() {
    return {
      'employeename': employeename,
      'pin': pin,
      'perhourrate': perhourrate,
      'in': In,
      'out': out,
      'difference': difference
    };
  }

  static EmployeeModel fromJson(Map<String, Object?> json) {
    return EmployeeModel(
        employeename: json['employeename'] == null
            ? null
            : json['employeename'] as String,
        pin: json['pin'] == null ? null : json['pin'] as String,
        perhourrate:
            json['perhourrate'] == null ? null : json['perhourrate'] as String,
        In: json['in'] == null ? null : json['in'] as String,
        out: json['out'] == null ? null : json['out'] as String,
        difference:
            json['difference'] == null ? null : json['difference'] as String);
  }

  @override
  String toString() {
    return '''EmployeeModel(
                employeename:$employeename,
pin:$pin,
perhourrate:$perhourrate,
in:$In,
out:$out,
difference:$difference
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeModel &&
        other.runtimeType == runtimeType &&
        other.employeename == employeename &&
        other.pin == pin &&
        other.perhourrate == perhourrate &&
        other.In == In &&
        other.out == out &&
        other.difference == difference;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, employeename, pin, perhourrate, In, out, difference);
  }
}
