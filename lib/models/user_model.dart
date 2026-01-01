class User {
  final int? userid;
  final String name;
  final String email;
  final String phone;
  final String username;
  final String password;

  User({
    this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
      'phone': phone,
      'username': username,
      'password': password,
    };
  }
}
