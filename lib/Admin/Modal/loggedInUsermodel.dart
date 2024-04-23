class LoggedInUser {
  final String? username;
  const LoggedInUser({this.username});
  LoggedInUser copyWith({String? username}) {
    return LoggedInUser(username: username ?? this.username);
  }

  Map<String, Object?> toJson() {
    return {'username': username};
  }

  static LoggedInUser fromJson(Map<String, Object?> json) {
    return LoggedInUser(
        username: json['username'] == null ? null : json['username'] as String);
  }

  @override
  String toString() {
    return '''LoggedInUser(
                username:$username
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is LoggedInUser &&
        other.runtimeType == runtimeType &&
        other.username == username;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, username);
  }
}
