import 'dart:convert';

class UserCredentials {
  const UserCredentials({
    required this.email,
    required this.password,
    required this.name,
  });

  factory UserCredentials.fromString(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    return UserCredentials.fromJson(jsonMap as Map<String, dynamic>);
  }

  factory UserCredentials.fromJson(Map<String, dynamic> json) {
    return UserCredentials(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );
  }
  final String email;
  final String password;
  final String name;

  Map<String, String> toJson() => {
        'email': email,
        'password': password,
        'name': name,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
