import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<FirebaseUser> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    assert(user != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    return user?.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    assert (user != null);
    assert (await user.getIdToken() != null);
    return user?.uid;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

//  @override
//  Future<String> currentUser() async {
//    final FirebaseUser user = await _firebaseAuth.currentUser();
//    return user?.uid;
//  }

  @override
  Future<FirebaseUser> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

//  @override
  Future<String> currentUserEmail() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.email;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
