class UserData {
  final String email;
  final String name;
  final String uid;

  UserData({required this.email, required this.name, required this.uid});

  Map<String, dynamic> toJson() => {
    "email": email,
    "username": name,
    "uid": uid,
  };
}
