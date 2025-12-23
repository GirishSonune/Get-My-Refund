import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Currently signed-in Firebase user, or null when not signed in.
  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Send a password reset email to the given address.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  Future<void> signOut() => _auth.signOut();

  /// Sign out from Firebase and also try to sign out from Google/Facebook
  /// to avoid leaving cached accounts on the device.
  Future<void> signOutAll() async {
    try {
      // Firebase sign out
      await _auth.signOut();
    } finally {
      // Best-effort sign out from Google
      try {
        final google = GoogleSignIn();
        if (await google.isSignedIn()) {
          await google.signOut();
        }
      } catch (_) {}

      // Best-effort sign out from Facebook
      try {
        await FacebookAuth.instance.logOut();
      } catch (_) {}
    }
  }

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email'],
        clientId: kIsWeb
            ? '512066556824-82u562i3v2fbeohlr44hk0bsjqovs500.apps.googleusercontent.com'
            : null,
      );
      final account = await googleSignIn.signIn();
      if (account == null) throw Exception('Google sign in aborted');
      final auth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  /// Sign in with Facebook
  Future<UserCredential> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        throw Exception('Facebook sign in failed: ${result.status}');
      }
      final accessToken = result.accessToken?.token;
      if (accessToken == null) throw Exception('Missing Facebook access token');
      final credential = FacebookAuthProvider.credential(accessToken);
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  /// Sign in with Apple
  Future<UserCredential> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // Needed for Android/Web:
        webAuthenticationOptions: (kIsWeb || defaultTargetPlatform == TargetPlatform.android)
            ? WebAuthenticationOptions(
                clientId: 'com.example.getMyRefund.service', // Update with your Service ID
                redirectUri: Uri.parse(
                  'https://get-my-refund-5096f.firebaseapp.com/__/auth/handler',
                ),
              )
            : null,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await _auth.signInWithCredential(oauthCredential);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  /// Verify phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      timeout: const Duration(seconds: 60),
    );
  }

  /// Sign in with Credential (generic, used for Phone too)
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    try {
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  // Microsoft / Azure AD sign-in is not implemented here. For Microsoft sign-in
  // you can use packages like `microsoft_authentication` or implement OAuth
  // manually and exchange tokens for Firebase credentials via
  // `OAuthProvider("microsoft.com")` if you have configured Microsoft as a
  // provider in Firebase Authentication. This typically requires platform
  // configuration and a Microsoft app registration.

  Exception _mapException(FirebaseAuthException e) {
    final code = e.code;
    switch (code) {
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'user-disabled':
        return Exception('User disabled');
      case 'user-not-found':
        return Exception('No user found for that email');
      case 'wrong-password':
        return Exception('Wrong password provided');
      case 'email-already-in-use':
        return Exception('Email already in use');
      case 'weak-password':
        return Exception('Password is too weak');
      default:
        return Exception(e.message ?? 'Authentication error');
    }
  }
}
