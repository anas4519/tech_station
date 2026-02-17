import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.avatarUrl,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromSupabaseUser(
    Map<String, dynamic> userData,
    String id,
    String email,
  ) {
    return UserModel(
      id: id,
      email: email,
      displayName:
          userData['display_name'] as String? ??
          userData['full_name'] as String? ??
          userData['name'] as String?,
      avatarUrl: userData['avatar_url'] as String?,
      createdAt: userData['created_at'] != null
          ? DateTime.parse(userData['created_at'] as String)
          : null,
    );
  }
}
