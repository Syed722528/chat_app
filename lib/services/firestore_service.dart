import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static Future<void> updateCurrentUserName(String name) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'userName': name});
    } on FirebaseException catch (e) {
      throw e.message ?? 'An unknown error occured';
    }
  }


}
