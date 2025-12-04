import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'splash_screen.dart';
import '../services/user_service.dart';
import '../main.dart';

/// Shows the HomePage when a user is signed in, otherwise shows LoginPage.
///
/// This keeps the UI in sync with the Firebase auth state and avoids
/// accidental navigation-based 'logout' experiences when the app restarts
/// or is resumed.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  static final _userService = UserService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While checking auth state, show a small loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) return const SplashScreen();

        return const HomePage();
      },
    );
  }
}
