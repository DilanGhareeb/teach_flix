import 'dart:async';
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
  Stream<Either<Failure, UserModel>> watchUserById({required String uid});
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

  AuthApiDatasourceImpl({
    FirebaseFirestore? fireStore,
    FirebaseAuth? fireAuth,
    fs.FirebaseStorage? storage,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance,
       _fireAuth = fireAuth ?? FirebaseAuth.instance;

  @override
  Stream<AuthSession> watchSession() => _fireAuth.idTokenChanges().map(
    (user) => AuthSession(isAuthenticated: user != null, uid: user?.uid),
  );

  @override
  Stream<Either<Failure, UserModel>> watchUserById({required String uid}) {
    final ref = _fireStore.collection(_users).doc(uid);

    return ref.snapshots().transform(
      StreamTransformer.fromHandlers(
        handleData:
            (
              DocumentSnapshot<Map<String, dynamic>> snap,
              EventSink<Either<Failure, UserModel>> sink,
            ) {
              final data = snap.data();

              if (!snap.exists || data == null) {
                sink.add(const Left(UnknownFailure()));
                return;
              }

              try {
                final model = UserModel.fromMap({...data, 'id': snap.id});
                sink.add(Right(model));
              } catch (_) {
                sink.add(const Left(UnknownFailure()));
              }
            },
        handleError:
            (error, stackTrace, EventSink<Either<Failure, UserModel>> sink) {
              if (error is FirebaseException) {
                sink.add(Left(FirestoreFailure.fromFirebaseCode(error.code)));
              } else {
                sink.add(const Left(UnknownFailure()));
              }
            },
      ),
    );
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

      final doc = _fireStore.collection(_users).doc(uid);

      final now = DateTime.now().toUtc();
      final userData = <String, dynamic>{
        'id': uid,
        'email': params.email,
        'name': params.name,
        'gender': params.gender,
        'isEmailVerified': cred.user?.emailVerified ?? false,
        'role': 'student',
        'createdAt': now,
        'updatedAt': now,
      };

      await doc.set(userData, SetOptions(merge: true));

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
