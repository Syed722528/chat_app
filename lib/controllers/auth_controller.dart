import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final AuthService _auth;
  AuthController(this._auth) : super(const AsyncValue.data(null));
  Future<void> signUp(String email, String password) async {
    state = AsyncValue.loading();
    try {
      final user = await _auth.createUserWithEmail(
        email.trim(),
        password.trim(),
      );
      state = AsyncValue.data(user.user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signIn(String email, String password) async {}
}

final authServiceProvider = Provider((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>(
  (ref) => AuthController(ref.read(authServiceProvider)),
);
