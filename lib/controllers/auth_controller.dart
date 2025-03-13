import 'package:chat_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

import '../models/user_model.dart';

class SignOutController extends StateNotifier<AsyncValue<User?>> {
  final AuthService _auth;
  SignOutController(this._auth) : super(const AsyncValue.data(null));

  Future<void> signOut() async {
    state = AsyncValue.loading();
    try {
      await _auth.signOutUser();

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

class SignupController extends StateNotifier<AsyncValue<User?>> {
  final AuthService _auth;
  SignupController(this._auth) : super(const AsyncValue.data(null));
  Future<void> signUp(String email, String password) async {
    state = AsyncValue.loading();
    try {
      final tempUser = await _auth.createUserWithEmail(
        email.trim(),
        password.trim(),
      );
      final user = UserModel(
        uid: tempUser.user!.uid,
        email: email.trim(),
        password: password.trim(),
        userName: tempUser.user!.displayName??'User',
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(tempUser.user!.uid)
          .set(user.toMap());
      state = AsyncValue.data(tempUser.user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

class SigninController extends StateNotifier<AsyncValue<User?>> {
  final AuthService _auth;
  SigninController(this._auth) : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = AsyncValue.loading();
    try {
      final tempUser = await _auth.signinUserWithEmail(
        email.trim(),
        password.trim(),
      );
      final user = UserModel(
        uid: tempUser.user!.uid,
        email: email.trim(),
        password: password.trim(),
        userName: tempUser.user!.displayName ?? 'User',
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(tempUser.user!.uid)
          .set(user.toMap(), SetOptions(merge: true));

      state = AsyncValue.data(tempUser.user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
