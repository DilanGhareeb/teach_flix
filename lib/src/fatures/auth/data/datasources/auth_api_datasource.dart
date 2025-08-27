import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/auth/data/models/user_model.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';

abstract class AuthApiDatasource {
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> registerAccount({
    required RegisterParams params,
  });

  Future<Either<Failure, void>> signOut();
}

class AuthApiDatasourceImpl implements AuthApiDatasource {
  final _fireStore = FirebaseFirestore.instance;
  final _fireAuth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _fireAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _fireStore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      final map = userDoc.data();

      if (map == null) {
        return Left(UnknownFailure());
      }

      return Right(UserModel.fromMap(map));
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> registerAccount({
    required RegisterParams params,
  }) async {
    try {
      final registerResult = await _fireAuth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      final user = registerResult.user;

      _fireStore.collection('users').doc(user?.uid).set({
        'id': user?.uid,
        'email': params.email,
        'name': params.name,
        'gender': params.gender,
        'profilePictureUrl': params.profilePictureUrl,
        'isEmailVerified': false,
        'role': 'student',
      });

      final userDoc = await _fireStore.collection('users').doc(user?.uid).get();

      if (userDoc.data() != null) {
        return Right(UserModel.fromMap(userDoc.data()!));
      } else {
        return Left(UnknownFailure());
      }
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
