import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/auth/data/models/user_model.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/auth_session.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/update_user_info_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/deposit_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/withdraw_usecase.dart';

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
  Future<Either<Failure, UserEntity>> updateUserInfo({
    required UpdateUserParams params,
  });
  Future<Either<Failure, UserEntity>> deposit({required DepositParams params});
  Future<Either<Failure, UserEntity>> withdraw({
    required WithdrawParams params,
  });
  Future<Either<Failure, void>> signOut();
}

class AuthApiDatasourceImpl implements AuthApiDatasource {
  final FirebaseFirestore _fireStore;
  final FirebaseAuth _fireAuth;
  final fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
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
      return Left(AuthFailure.fromFirebaseAuthCode(e.code));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
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
        'balance': 0.0,
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
  Future<Either<Failure, UserEntity>> updateUserInfo({
    required UpdateUserParams params,
  }) async {
    try {
      final user = _fireAuth.currentUser;
      if (user == null) {
        return left(AuthFailure.fromFirebaseAuthCode("user-not-found"));
      }

      final uid = user.uid;
      final userRef = _fireStore.collection('users').doc(uid);

      final updateMap = params.toMap();

      // Handle photo removal
      if (params.removePhoto) {
        // Delete the old photo from storage if it exists
        try {
          final ref = storage.ref().child('user_avatars').child('$uid.jpg');
          await ref.delete();
        } catch (e) {
          // Photo might not exist, ignore the error
          print('Photo deletion skipped: $e');
        }
        // Set avatarUrl to null in Firestore
        updateMap['avatarUrl'] = null;
      }
      // Handle new photo upload
      else if (params.imageProfile != null) {
        final ref = storage.ref().child('user_avatars').child('$uid.jpg');
        await ref.putData(
          params.imageProfile!,
          fs.SettableMetadata(contentType: 'image/jpeg'),
        );
        final avatarUrl = await ref.getDownloadURL();
        updateMap['avatarUrl'] = avatarUrl;
      }

      // Always update the updatedAt timestamp
      updateMap['updatedAt'] = FieldValue.serverTimestamp();

      if (updateMap.isEmpty) {
        return left(UnknownFailure());
      }

      await userRef.update(updateMap);

      final updatedSnap = await userRef.get();
      final data = updatedSnap.data();

      if (data == null) {
        return left(UnknownFailure());
      }

      final updatedModel = UserModel.fromMap({...data, 'id': uid});

      return right(updatedModel);
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure.fromFirebaseAuthCode(e.code));
    } on FirebaseException catch (e) {
      return left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> deposit({
    required DepositParams params,
  }) async {
    try {
      final user = _fireAuth.currentUser;
      if (user == null) {
        return left(AuthFailure.fromFirebaseAuthCode("user-not-found"));
      }

      final uid = user.uid;
      final userRef = _fireStore.collection(_users).doc(uid);

      // Use a transaction to safely update the balance
      await _fireStore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        final currentBalance =
            (snapshot.data()?['balance'] as num?)?.toDouble() ?? 0.0;
        final newBalance = currentBalance + params.amount;

        transaction.update(userRef, {
          'balance': newBalance,
          'updatedAt': DateTime.now().toUtc(),
        });
      });

      final updatedSnap = await userRef.get();
      final updatedModel = UserModel.fromMap(updatedSnap.data()!..['id'] = uid);

      return right(updatedModel);
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure.fromFirebaseAuthCode(e.code));
    } on FirebaseException catch (e) {
      return left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> withdraw({
    required WithdrawParams params,
  }) async {
    try {
      final user = _fireAuth.currentUser;
      if (user == null) {
        return left(AuthFailure.fromFirebaseAuthCode("user-not-found"));
      }

      final uid = user.uid;
      final userRef = _fireStore.collection(_users).doc(uid);

      // Use a transaction to safely update the balance
      await _fireStore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        final currentBalance =
            (snapshot.data()?['balance'] as num?)?.toDouble() ?? 0.0;

        // Check if user has sufficient balance
        if (currentBalance < params.amount) {
          throw Exception("Insufficient balance");
        }

        final newBalance = currentBalance - params.amount;

        transaction.update(userRef, {
          'balance': newBalance,
          'updatedAt': DateTime.now().toUtc(),
        });
      });

      final updatedSnap = await userRef.get();
      final updatedModel = UserModel.fromMap(updatedSnap.data()!..['id'] = uid);

      return right(updatedModel);
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure.fromFirebaseAuthCode(e.code));
    } on FirebaseException catch (e) {
      return left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      if (e.toString().contains("Insufficient balance")) {
        return left(
          UnknownFailure(),
        ); // You can create a custom InsufficientBalanceFailure
      }
      return left(UnknownFailure());
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
