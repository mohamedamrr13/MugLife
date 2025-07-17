import 'package:bloc/bloc.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'google_state.dart';

class GoogleCubit extends Cubit<GoogleState> {
  GoogleCubit() : super(GoogleInitial());

  Future<UserCredential?> signUpWithGoogle() async {
    emit(GoogleLoading());
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        emit(GoogleFailure(errMessage: "Google Sign-In was canceled"));
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      emit(GoogleSuccess());
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint(Failure.getMessageFromErrorCode(e.code));
      emit(GoogleFailure(errMessage: Failure.getMessageFromErrorCode(e.code)));
    } catch (e) {
      debugPrint("Unexpected error: $e");
      emit(GoogleFailure(errMessage: "Google Sign-In was canceled"));
    }
    return null;
  }
}
// no need for gapi.client since firebase is used ///mohameed