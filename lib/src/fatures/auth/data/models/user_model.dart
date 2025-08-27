import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.createdAt,
    required this.updatedAt,
    required super.id,
    required super.email,
    required super.name,
    required super.gender,
    required super.isEmailVerified,
    required super.role,
    super.profilePictureUrl,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      gender: gender,
      profilePictureUrl: profilePictureUrl,
      isEmailVerified: isEmailVerified,
      role: role,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      profilePictureUrl: map['profilePictureUrl'],
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      isEmailVerified: map['isEmailVerified'],
      role: map['role'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    gender,
    profilePictureUrl,
    createdAt,
    updatedAt,
    isEmailVerified,
    role,
  ];
}
