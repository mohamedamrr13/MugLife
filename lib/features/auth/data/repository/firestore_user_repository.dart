import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/core/services/firestore_service.dart';
import 'package:drinks_app/features/auth/data/models/user_model.dart';
import 'package:drinks_app/features/auth/data/repository/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Firestore implementation of UserRepository
class FirestoreUserRepository implements UserRepository {
  final FirestoreService _firestoreService;
  final FirebaseStorage _firebaseStorage;

  FirestoreUserRepository(
    this._firestoreService,
    this._firebaseStorage,
  );

  static const String _usersCollection = 'users';

  @override
  Future<Either<Failure, UserModel>> getUserProfile({
    required String userId,
  }) async {
    try {
      final doc = await _firestoreService.getDocument(
        collectionPath: _usersCollection,
        documentId: userId,
      );

      if (doc == null || !doc.exists) {
        return Left(FirebaseFailure(message: 'User profile not found'));
      }

      final user = UserModel.fromDocument(doc);
      return Right(user);
    } catch (e) {
      return Left(FirebaseFailure(
        message: 'Failed to get user profile: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> createUserProfile({
    required UserModel user,
  }) async {
    try {
      await _firestoreService.setDocument(
        collectionPath: _usersCollection,
        documentId: user.id,
        data: user.toMap(),
      );
      return const Right(null);
    } catch (e) {
      return Left(FirebaseFailure(
        message: 'Failed to create user profile: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _usersCollection,
        documentId: userId,
        data: updates,
      );
      return const Right(null);
    } catch (e) {
      return Left(FirebaseFailure(
        message: 'Failed to update user profile: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto({
    required String userId,
    required File photoFile,
  }) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      final storageRef = _firebaseStorage.ref();
      final profilePhotoRef =
          storageRef.child('users/$userId/profile_photo.jpg');

      // Upload the file
      await profilePhotoRef.putFile(photoFile);

      // Get the download URL
      final downloadUrl = await profilePhotoRef.getDownloadURL();

      return Right(downloadUrl);
    } catch (e) {
      return Left(FirebaseFailure(
        message: 'Failed to upload profile photo: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfilePhoto({
    required String userId,
    required String photoUrl,
  }) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _usersCollection,
        documentId: userId,
        data: {
          'photoUrl': photoUrl,
          'updatedAt': DateTime.now(),
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(FirebaseFailure(
        message: 'Failed to update profile photo URL: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfilePhoto({
    required String userId,
  }) async {
    try {
      // Delete from Firebase Storage
      final storageRef = _firebaseStorage.ref();
      final profilePhotoRef =
          storageRef.child('users/$userId/profile_photo.jpg');

      try {
        await profilePhotoRef.delete();
      } catch (e) {
        // Photo might not exist in storage, continue to update Firestore
      }

      // Update Firestore to remove photo URL
      await _firestoreService.updateDocument(
        collectionPath: _usersCollection,
        documentId: userId,
        data: {
          'photoUrl': null,
          'updatedAt': DateTime.now(),
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(FirebaseFailure(
        message: 'Failed to delete profile photo: ${e.toString()}',
      ));
    }
  }
}
