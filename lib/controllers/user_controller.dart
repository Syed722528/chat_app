import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});


final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final userProvider = StreamProvider<UserModel?>((ref) {
  final auth = ref.watch(authStateProvider).asData?.value;
  if (auth == null) return Stream.value(null);

  final firestore = ref.watch(firestoreProvider);

  return firestore.collection('users').doc(auth.uid).snapshots().map((
    snapshot,
  ) {
    if (snapshot.exists && snapshot.data() != null) {
      return UserModel.fromMap(snapshot.data()!, auth.uid);
    }
    return null;
  });
});
