// For password visibility in Login Page

import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordVisibilityProviderLogin = StateProvider<bool>((ref) {
  return false;
});
// For password visibility in Sign up Page
final passwordVisibilityProviderSignUp = StateProvider<bool>((ref) {
  return false;
});

// For confirm password visibility in Sign up Page
final confirmPasswordVisibilityProviderSignUp = StateProvider<bool>((ref) {
  return false;
});

final authServiceProvider = Provider((ref) => AuthService());

final signupProvider =
    StateNotifierProvider<SignupController, AsyncValue<User?>>((ref) {
      return SignupController(ref.read(authServiceProvider));
    });

final signinProvider =
    StateNotifierProvider<SigninController, AsyncValue<User?>>((ref) {
      return SigninController(ref.read(authServiceProvider));
    });

final signOutProvider =
    StateNotifierProvider<SignOutController, AsyncValue<User?>>((ref) {
      return SignOutController(ref.read(authServiceProvider));
    });
