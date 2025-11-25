import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/features/auth/data/models/user_model.dart';

/// Abstract repository for user profile operations
abstract class UserRepository {
  Future<Either<Failure, UserModel>> getUserProfile({required String userId});

  Future<Either<Failure, void>> createUserProfile({
    required UserModel user,
  });

  Future<Either<Failure, void>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  });

  Future<Either<Failure, String>> uploadProfilePhoto({
    required String userId,
    required File photoFile,
  });

  Future<Either<Failure, void>> updateProfilePhoto({
    required String userId,
    required String photoUrl,
  });

  Future<Either<Failure, void>> deleteProfilePhoto({required String userId});
}
