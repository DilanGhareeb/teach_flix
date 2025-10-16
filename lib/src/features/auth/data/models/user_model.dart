import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.createdAt,
    required this.updatedAt,
    required super.id,
    required super.email,
    required super.name,
    required super.balance,
    required super.gender,
    required super.isEmailVerified,
    required super.role,
    super.profilePictureUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final roleRaw = (map['role'] ?? '').toString().toLowerCase();
    final role = switch (roleRaw) {
      'admin' => Role.admin,
      'instructor' => Role.instructor,
      _ => Role.student,
    };

    DateTime parseTimestamp(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      if (value is String) {
        return DateTime.tryParse(value) ??
            DateTime.fromMillisecondsSinceEpoch(0);
      }
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return UserModel(
      id: (map['id'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      gender: (map['gender'] ?? '').toString(),
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      profilePictureUrl: map['avatarUrl'] as String?,
      createdAt: parseTimestamp(map['createdAt']),
      updatedAt: parseTimestamp(map['updatedAt']),
      isEmailVerified: (map['isEmailVerified'] as bool?) ?? false,
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
    balance,
    createdAt,
    updatedAt,
    isEmailVerified,
    role,
  ];
}
