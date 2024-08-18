import 'package:yomu_no_ikiru/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      email: json["email"] ?? "",
      username: json["username"] ?? "",
      avatarUrl: json["avatar_url"] ?? "",
    );
  }
}
