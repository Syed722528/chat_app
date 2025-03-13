class UserModel {
  String uid;
  String? userName;
  String email;
  String password;

  UserModel({
    required this.uid,
    required this.email,
    required this.password,
    this.userName,
  });

  String get displayName => userName ?? 'User';

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'userName': userName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map,String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      userName: map['userName'],
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory UserModel.fromJson(Map<String, dynamic> json,String uid) =>
      UserModel.fromMap(json,uid);
}
