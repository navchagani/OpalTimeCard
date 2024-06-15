class LoggedInUser {
  String? businessId;
  String? uid;
  String? username;
  String? email;
  String? businessName;
  List<Employees>? employees;

  LoggedInUser(
      {this.businessId,
      this.uid,
      this.username,
      this.email,
      this.businessName,
      this.employees});

  LoggedInUser copyWith(
      {String? uid,
      String? businessId,
      String? username,
      String? email,
      String? businessName,
      List<Employees>? employees}) {
    return LoggedInUser(
        businessId: businessId ?? this.businessId,
        uid: uid ?? this.uid,
        username: username ?? this.username,
        email: email ?? this.email,
        businessName: businessName ?? this.businessName,
        employees: employees ?? this.employees);
  }

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'business_id': businessId,
      'username': username,
      'email': email,
      'business_name': businessName,
      'employees':
          employees?.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static LoggedInUser fromJson(Map<String, Object?> json) {
    return LoggedInUser(
        uid: json['uid'] == null ? null : json['uid'] as String,
        businessId:
            json['business_id'] == null ? null : json['business_id'] as String,
        username: json['username'] == null ? null : json['username'] as String,
        email: json['email'] == null ? null : json['email'] as String,
        businessName: json['business_name'] == null
            ? null
            : json['business_name'] as String,
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
                uid:$uid,
                business_id:$businessId,
                username:$username,
                email:$email,
                business_name:$businessName,
                employees:${employees.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is LoggedInUser &&
        other.runtimeType == runtimeType &&
        other.uid == uid &&
        other.businessId == businessId &&
        other.username == username &&
        other.email == email &&
        other.businessName == businessName &&
        other.employees == employees;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, uid, businessId, username, email, businessName, employees);
  }
}

class Employees {
  final int? id;
  final String? name;
  final String? pin;
  final String? starttime;
  final String? endtime;
  const Employees({this.id, this.name, this.pin, this.starttime, this.endtime});
  Employees copyWith(
      {int? id,
      String? name,
      String? pin,
      String? starttime,
      String? endtime}) {
    return Employees(
        id: id ?? this.id,
        name: name ?? this.name,
        pin: pin ?? this.pin,
        starttime: starttime ?? this.starttime,
        endtime: endtime ?? this.endtime);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'pin': pin,
      'starttime': starttime,
      'endtime': endtime
    };
  }

  static Employees fromJson(Map<String, Object?> json) {
    return Employees(
        id: json['id'] == null ? null : json['id'] as int,
        name: json['name'] == null ? null : json['name'] as String,
        pin: json['pin'] == null ? null : json['pin'] as String,
        starttime:
            json['starttime'] == null ? null : json['starttime'] as String,
        endtime: json['endtime'] == null ? null : json['endtime'] as String);
  }

  @override
  String toString() {
    return '''Employees(
                id:$id,
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
        other.id == id &&
        other.name == name &&
        other.pin == pin &&
        other.starttime == starttime &&
        other.endtime == endtime;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, name, pin, starttime, endtime);
  }
}
