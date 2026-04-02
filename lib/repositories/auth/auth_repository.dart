import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User?> signInWithGoogle();

  Future<void> signOut();

  Stream<User?> get currentUser;

  /// Starts phone verification. Callbacks for different verification states.
  Future verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException error) verificationFailed,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
  });

  /// Verifies the OTP and signs in the user
  Future<UserCredential?> confirmPhoneVerification(
    String verificationId,
    String smsCode,
  );
}
