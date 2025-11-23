import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:drinks_app/features/auth/data/models/user_model.dart';
import 'package:drinks_app/features/auth/data/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(UserInitial());

  Future<void> getUserProfile({required String userId}) async {
    emit(UserLoading());

    final result = await _userRepository.getUserProfile(userId: userId);

    result.fold(
      (failure) => emit(UserFailure(errMessage: failure.message)),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> createUserProfile({required UserModel user}) async {
    emit(UserLoading());

    final result = await _userRepository.createUserProfile(user: user);

    result.fold((failure) => emit(UserFailure(errMessage: failure.message)), (
      _,
    ) {
      emit(UserProfileCreated());
      getUserProfile(userId: user.id);
    });
  }

  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    emit(UserLoading());

    final result = await _userRepository.updateUserProfile(
      userId: userId,
      updates: updates,
    );

    result.fold((failure) => emit(UserFailure(errMessage: failure.message)), (
      _,
    ) {
      emit(UserProfileUpdated());
      getUserProfile(userId: userId);
    });
  }

  Future<void> uploadProfilePhoto({
    required String userId,
    required File photoFile,
  }) async {
    emit(UserUploadingPhoto());

    final uploadResult = await _userRepository.uploadProfilePhoto(
      userId: userId,
      photoFile: photoFile,
    );

    await uploadResult.fold(
      (failure) async {
        emit(UserFailure(errMessage: failure.message));
      },
      (photoUrl) async {
        final updateResult = await _userRepository.updateProfilePhoto(
          userId: userId,
          photoUrl: photoUrl,
        );

        updateResult.fold(
          (failure) => emit(UserFailure(errMessage: failure.message)),
          (_) {
            emit(UserPhotoUpdated(photoUrl: photoUrl));
            getUserProfile(userId: userId);
          },
        );
      },
    );
  }

  Future<void> deleteProfilePhoto({required String userId}) async {
    emit(UserLoading());

    final result = await _userRepository.deleteProfilePhoto(userId: userId);

    result.fold((failure) => emit(UserFailure(errMessage: failure.message)), (
      _,
    ) {
      emit(UserPhotoDeleted());
      getUserProfile(userId: userId);
    });
  }
}
