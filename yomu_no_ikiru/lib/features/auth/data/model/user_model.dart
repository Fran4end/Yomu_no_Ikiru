import 'package:yomu_no_ikiru/core/common/entities/user.dart';

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

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
