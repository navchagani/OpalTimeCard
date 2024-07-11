class LoggedInUser {
  final String? uid;
  final String? username;
  final String? email;
  final String? businessName;
  final String? businessId;
  final int? deviceId;
  final List<Employees>? employees;

  const LoggedInUser({
    this.uid,
    this.username,
    this.email,
    this.businessName,
    this.businessId,
    this.deviceId,
    this.employees,
  });

  LoggedInUser copyWith({
    String? uid,
    String? username,
    String? email,
    String? businessName,
    String? businessId,
    int? deviceId,
    List<Employees>? employees,
  }) {
    return LoggedInUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      businessName: businessName ?? this.businessName,
      businessId: businessId ?? this.businessId,
      deviceId: deviceId ?? this.deviceId,
      employees: employees ?? this.employees,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'business_name': businessName,
      'business_id': businessId,
      'device_id': deviceId,
      'employees': employees?.map((data) => data.toJson()).toList(),
    };
  }

  factory LoggedInUser.fromJson(Map<String, Object?> json) {
    return LoggedInUser(
      uid: json['uid'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      businessName: json['business_name'] as String?,
      businessId: json['business_id'] as String?,
      deviceId: json['device_id'] as int?,
      employees: (json['employees'] as List?)
          ?.map((data) => Employees.fromJson(data as Map<String, Object?>))
          .toList(),
    );
  }

  // factory LoggedInUser.fromFirestore(DocumentSnapshot doc) {
  //   Map<String, Object?> json = doc.data() as Map<String, Object?>;
  //   return LoggedInUser.fromJson(json);
  // }

  Map<String, Object?> toFirestore() {
    return toJson();
  }

  @override
  String toString() {
    return '''LoggedInUser(
      uid: $uid,
      username: $username,
      email: $email,
      businessName: $businessName,
      businessId: $businessId,
      deviceId: $deviceId,
      employees: ${employees.toString()}
    )''';
  }

  @override
  bool operator ==(Object other) {
    return other is LoggedInUser &&
        other.runtimeType == runtimeType &&
        other.uid == uid &&
        other.username == username &&
        other.email == email &&
        other.businessName == businessName &&
        other.businessId == businessId &&
        other.deviceId == deviceId &&
        other.employees == employees;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, uid, username, email, businessName,
        businessId, deviceId, employees);
  }
}

class Employees {
  final int? id;
  final String? name;
  final String? pin;
  final String? starttime;
  final String? endtime;
  final List<Alldepartment>? alldepartment;

  const Employees({
    this.id,
    this.name,
    this.pin,
    this.starttime,
    this.endtime,
    this.alldepartment,
  });

  Employees copyWith({
    int? id,
    String? name,
    String? pin,
    String? starttime,
    String? endtime,
    List<Alldepartment>? alldepartment,
  }) {
    return Employees(
      id: id ?? this.id,
      name: name ?? this.name,
      pin: pin ?? this.pin,
      starttime: starttime ?? this.starttime,
      endtime: endtime ?? this.endtime,
      alldepartment: alldepartment ?? this.alldepartment,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'pin': pin,
      'starttime': starttime,
      'endtime': endtime,
      'alldepartment': alldepartment
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
    };
  }

  factory Employees.fromJson(Map<String, Object?> json) {
    return Employees(
      id: json['id'] as int?,
      name: json['name'] as String?,
      pin: json['pin'] as String?,
      starttime: json['starttime'] as String?,
      endtime: json['endtime'] as String?,
      alldepartment: (json['alldepartment'] as List?)
          ?.map((data) => Alldepartment.fromJson(data as Map<String, Object?>))
          .toList(),
    );
  }

  // factory Employees.fromFirestore(DocumentSnapshot doc) {
  //   Map<String, Object?> json = doc.data() as Map<String, Object?>;
  //   return Employees.fromJson(json);
  // }

  Map<String, Object?> toFirestore() {
    return toJson();
  }

  @override
  String toString() {
    return '''Employees(
      id:$id,
      name:$name,
      pin:$pin,
      starttime:$starttime,
      endtime:$endtime,
      alldepartment:${alldepartment.toString()}
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
        other.endtime == endtime &&
        other.alldepartment == alldepartment;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, id, name, pin, starttime, endtime, alldepartment);
  }
}

class Alldepartment {
  final Department? department;

  const Alldepartment({this.department});

  Alldepartment copyWith({Department? department}) {
    return Alldepartment(department: department ?? this.department);
  }

  Map<String, Object?> toJson() {
    return {'department': department?.toJson()};
  }

  factory Alldepartment.fromJson(Map<String, Object?> json) {
    return Alldepartment(
      department: json['department'] == null
          ? null
          : Department.fromJson(json['department'] as Map<String, Object?>),
    );
  }

  // factory Alldepartment.fromFirestore(DocumentSnapshot doc) {
  //   Map<String, Object?> json = doc.data() as Map<String, Object?>;
  //   return Alldepartment.fromJson(json);
  // }

  Map<String, Object?> toFirestore() {
    return toJson();
  }

  @override
  String toString() {
    return '''Alldepartment(
      department:${department.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Alldepartment &&
        other.runtimeType == runtimeType &&
        other.department == department;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, department);
  }
}

class Department {
  final int? id;
  final String? name;

  const Department({this.id, this.name});

  Department copyWith({int? id, String? name}) {
    return Department(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'name': name};
  }

  factory Department.fromJson(Map<String, Object?> json) {
    return Department(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  // factory Department.fromFirestore(DocumentSnapshot doc) {
  //   Map<String, Object?> json = doc.data() as Map<String, Object?>;
  //   return Department.fromJson(json);
  // }

  Map<String, Object?> toFirestore() {
    return toJson();
  }

  @override
  String toString() {
    return '''Department(
      id:$id,
      name:$name
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Department &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, name);
  }
}
