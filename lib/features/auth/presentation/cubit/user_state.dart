part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserUploadingPhoto extends UserState {}

final class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded({required this.user});
}

final class UserProfileCreated extends UserState {}

final class UserProfileUpdated extends UserState {}

final class UserPhotoUpdated extends UserState {
  final String photoUrl;
  UserPhotoUpdated({required this.photoUrl});
}

final class UserPhotoDeleted extends UserState {}

final class UserFailure extends UserState {
  final String errMessage;
  UserFailure({required this.errMessage});
}
