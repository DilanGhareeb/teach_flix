import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/auth/data/models/user_model.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/auth_session.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';

abstract class AuthApiDatasource {
  Stream<AuthSession> watchSession();
  Future<Either<Failure, UserModel>> fetchUserById({required String uid});
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
  final fs.FirebaseStorage _storage;
  static const _users = 'users';

  AuthApiDatasourceImpl({
    FirebaseFirestore? fireStore,
    FirebaseAuth? fireAuth,
    fs.FirebaseStorage? storage,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance,
       _fireAuth = fireAuth ?? FirebaseAuth.instance,
       _storage = storage ?? fs.FirebaseStorage.instance;

  @override
  Stream<AuthSession> watchSession() =>
      _fireAuth.authStateChanges().map((user) => AuthSession(uid: user?.uid));

  @override
  Future<Either<Failure, UserModel>> fetchUserById({
    required String uid,
  }) async {
    try {
      final snap = await _fireStore.collection(_users).doc(uid).get();
      final data = snap.data();
      if (data == null) {
        return const Left(UnknownFailure());
      }
      return Right(UserModel.fromMap(data));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      inspect(e);
      return const Left(UnknownFailure());
    }
  }

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
      if (uid == null) {
        return const Left(UnknownFailure());
      }
      final snap = await _fireStore.collection(_users).doc(uid).get();
      final data = snap.data();
      if (data == null) {
        return const Left(UnknownFailure());
      }
      return Right(UserModel.fromMap(data));
    } on FirebaseAuthException catch (e) {
      inspect(e);
      return Left(AuthFailure.fromFirebaseAuthCode(e.code));
    } on FirebaseException catch (e) {
      inspect(e);
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      inspect(e);
      return const Left(UnknownFailure());
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
      if (uid == null) {
        return const Left(UnknownFailure());
      }

      String? downloadUrl;
      if (params.profilePictureBytes != null &&
          params.profilePictureBytes!.isNotEmpty) {
        final fileName =
            (params.profilePictureFileName?.trim().isNotEmpty ?? false)
            ? params.profilePictureFileName!.trim()
            : 'avatar.jpg';
        final ref = _storage.ref().child('users/$uid/$fileName');
        await ref.putData(
          params.profilePictureBytes!,
          fs.SettableMetadata(contentType: 'image/jpeg'),
        );
        downloadUrl = await ref.getDownloadURL();
      }

      final doc = _fireStore.collection(_users).doc(uid);
      await doc.set({
        'id': uid,
        'email': params.email,
        'name': params.name,
        'gender': params.gender,
        'profilePictureUrl': downloadUrl ?? params.profilePictureUrl,
        'isEmailVerified': cred.user?.emailVerified ?? false,
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final snap = await doc.get();
      final data = snap.data();
      if (data == null) {
        return const Left(UnknownFailure());
      }
      return Right(UserModel.fromMap(data));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromFirebaseAuthCode(e.code));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      inspect(e);
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _fireAuth.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromFirebaseAuthCode(e.code));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
