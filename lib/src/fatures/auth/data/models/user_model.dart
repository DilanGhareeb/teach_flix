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
      role: map['role'] == 'admin'
          ? Role.admin
          : map['role'] == 'instructor'
          ? Role.instructor
          : Role.student,
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
