class UserModel {
  final String id;
  final String username;
  final String? photo;
  final String? email; // adicionado

  UserModel({
    required this.id,
    required this.username,
    this.photo,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      username: json["username"],
      photo: json["photo"],
      email: json["email"],
    );
  }
}