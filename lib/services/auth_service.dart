import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Future<UserCredential> createUserWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknow error occured';
    }
  }

  Future<UserCredential> signinUserWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occured';
    }
  }

  Future<void> updateDisplayName(String name) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateDisplayName(name);
        _auth.currentUser!.reload();
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknow error occured';
    }
  }

  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknow error occured';
    }
  }
}
