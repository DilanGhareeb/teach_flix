import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';

class UpdateUserInfo extends Usecase<UpdateUserParams, UserEntity> {
  final AuthRepository repository;

  UpdateUserInfo(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call({required UpdateUserParams params}) {
    return repository.updateUserInfo(params: params);
  }
}

class UpdateUserParams extends Equatable {
  final String? name;
  final String? gender;
  final Uint8List? imageProfile;

  const UpdateUserParams(this.name, this.gender, this.imageProfile);

  UpdateUserParams copyWith({
    String? name,
    String? gender,
    Uint8List? imageProfile,
  }) {
    return UpdateUserParams(
      name ?? this.name,
      gender ?? this.gender,
      imageProfile ?? this.imageProfile,
    );
  }

  Map<String, dynamic> toMap() => {
    if (name != null) 'name': name,
    if (gender != null) 'gender': gender,
  };

  @override
  List<Object?> get props => [name, gender, imageProfile];
}
