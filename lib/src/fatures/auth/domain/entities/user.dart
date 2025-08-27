import 'package:equatable/equatable.dart';

enum Role { student, instructor, admin }

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String gender;
  final String? profilePictureUrl;
  final bool isEmailVerified;
  final Role role;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.gender,
    this.profilePictureUrl,
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
    isEmailVerified,
    role,
  ];
}
