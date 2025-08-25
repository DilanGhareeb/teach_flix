import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String gender;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final Role role;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.gender,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    required this.role,
  });

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      gender: gender,
      profilePictureUrl: profilePictureUrl,
      isEmailVerified: isEmailVerified,
      role: role,
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
