import 'package:equatable/equatable.dart';

enum Role { student, instructor, admin }

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String gender;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final Role role;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.gender,
    required this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    required this.role,
  });

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
