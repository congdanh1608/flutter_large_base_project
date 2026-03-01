/// Unified user model — used across all layers (no separate entity class needed).
///
/// Manual fromJson / toJson — no code generation required.
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String name;
  final String? avatarUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String? ?? '',
        avatarUrl: json['avatar_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel && other.id == id && other.email == email);

  @override
  int get hashCode => Object.hash(id, email);

  @override
  String toString() => 'UserModel(id: $id, email: $email, name: $name)';
}
