class LoggedInUser {
  final String? username;
  final String? email;
  final String? locationId;
  final List<Employees>? employees;
  const LoggedInUser(
      {this.username, this.email, this.locationId, this.employees});
  LoggedInUser copyWith(
      {String? username,
      String? email,
      String? locationId,
      List<Employees>? employees}) {
    return LoggedInUser(
        username: username ?? this.username,
        email: email ?? this.email,
        locationId: locationId ?? this.locationId,
        employees: employees ?? this.employees);
  }

  Map<String, Object?> toJson() {
    return {
      'username': username,
      'email': email,
      'location_id': locationId,
      'employees':
          employees?.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static LoggedInUser fromJson(Map<String, Object?> json) {
    return LoggedInUser(
        username: json['username'] == null ? null : json['username'] as String,
        email: json['email'] == null ? null : json['email'] as String,
        locationId:
            json['location_id'] == null ? null : json['location_id'] as String,
        employees: json['employees'] == null
            ? null
            : (json['employees'] as List)
                .map<Employees>(
                    (data) => Employees.fromJson(data as Map<String, Object?>))
                .toList());
  }

  @override
  String toString() {
    return '''LoggedInUser(
                username:$username,
email:$email,
locationId:$locationId,
employees:${employees.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is LoggedInUser &&
        other.runtimeType == runtimeType &&
        other.username == username &&
        other.email == email &&
        other.locationId == locationId &&
        other.employees == employees;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, username, email, locationId, employees);
  }
}

class Employees {
  final String? name;
  final String? pin;
  final String? starttime;
  final String? endtime;
  const Employees({this.name, this.pin, this.starttime, this.endtime});
  Employees copyWith(
      {String? name, String? pin, String? starttime, String? endtime}) {
    return Employees(
        name: name ?? this.name,
        pin: pin ?? this.pin,
        starttime: starttime ?? this.starttime,
        endtime: endtime ?? this.endtime);
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'pin': pin,
      'starttime': starttime,
      'endtime': endtime
    };
  }

  static Employees fromJson(Map<String, Object?> json) {
    return Employees(
        name: json['name'] == null ? null : json['name'] as String,
        pin: json['pin'] == null ? null : json['pin'] as String,
        starttime:
            json['starttime'] == null ? null : json['starttime'] as String,
        endtime: json['endtime'] == null ? null : json['endtime'] as String);
  }

  @override
  String toString() {
    return '''Employees(
                name:$name,
pin:$pin,
starttime:$starttime,
endtime:$endtime
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Employees &&
        other.runtimeType == runtimeType &&
        other.name == name &&
        other.pin == pin &&
        other.starttime == starttime &&
        other.endtime == endtime;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, name, pin, starttime, endtime);
  }
}
