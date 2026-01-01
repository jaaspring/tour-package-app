class Admin {
  final int? adminid;
  final String username;
  final String password;

  Admin({
    this.adminid,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'adminid': adminid,
      'username': username,
      'password': password,
    };
  }
}
