class LoggedInUser {
  final String? username;
  final String? email;
  final String? locationId;
  const LoggedInUser({this.username, this.email, this.locationId});
  LoggedInUser copyWith({String? username, String? email, String? locationId}) {
    return LoggedInUser(
        username: username ?? this.username,
        email: email ?? this.email,
        locationId: locationId ?? this.locationId);
  }

  Map<String, Object?> toJson() {
    return {'username': username, 'email': email, 'location_id': locationId};
  }

  static LoggedInUser fromJson(Map<String, Object?> json) {
    return LoggedInUser(
        username: json['username'] == null ? null : json['username'] as String,
        email: json['email'] == null ? null : json['email'] as String,
        locationId:
            json['location_id'] == null ? null : json['location_id'] as String);
  }

  @override
  String toString() {
    return '''LoggedInUser(
                username:$username,
email:$email,
locationId:$locationId
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is LoggedInUser &&
        other.runtimeType == runtimeType &&
        other.username == username &&
        other.email == email &&
        other.locationId == locationId;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, username, email, locationId);
  }
}
