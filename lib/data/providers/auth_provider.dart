import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final FirebaseAuth _firebaseAuth;

  AuthProvider(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String get currentUserId =>
      _firebaseAuth.currentUser != null ? _firebaseAuth.currentUser!.uid : '';

  Future<String> signIn() async {
    try {
      final authResult = await _firebaseAuth.signInAnonymously();
      return authResult.user!.uid;
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
}
