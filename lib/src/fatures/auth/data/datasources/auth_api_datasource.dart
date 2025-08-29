import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _fireStore;
  final FirebaseAuth _fireAuth;
  static const _users = 'users';

  AuthApiDatasourceImpl({FirebaseFirestore? fireStore, FirebaseAuth? fireAuth})
    : _fireStore = fireStore ?? FirebaseFirestore.instance,
      _fireAuth = fireAuth ?? FirebaseAuth.instance;

  @override
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _fireAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user?.uid;
      if (uid == null) return Left(UnknownFailure());

      final snap = await _fireStore.collection(_users).doc(uid).get();
      final data = snap.data();
      if (data == null) {
        return Left(
          ServerFailure(message: 'User profile not found.', code: 404),
        );
      }

      return Right(UserModel.fromMap(data));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromFirebaseCode(e.code));
    } catch (e, st) {
      return Left(UnknownFailure(stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, UserModel>> registerAccount({
    required RegisterParams params,
  }) async {
    try {
      final cred = await _fireAuth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      final uid = cred.user?.uid;
      if (uid == null) return Left(UnknownFailure());

      final doc = _fireStore.collection(_users).doc(uid);

      await doc.set({
        'id': uid,
        'email': params.email,
        'name': params.name,
        'gender': params.gender,
        'profilePictureUrl': params.profilePictureUrl,
        'isEmailVerified': cred.user?.emailVerified ?? false,
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final snap = await doc.get();
      final data = snap.data();
      if (data == null) return Left(UnknownFailure());

      return Right(UserModel.fromMap(data));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromFirebaseCode(e.code));
    } catch (e, st) {
      return Left(UnknownFailure(stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _fireAuth.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromFirebaseCode(e.code));
    } catch (e, st) {
      return Left(UnknownFailure(stackTrace: st));
    }
  }
}
