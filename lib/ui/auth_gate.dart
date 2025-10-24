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

        // Try to load user's saved locale and apply it. This is best-effort
        // and does not block showing the HomePage. Capture the uid and
        // schedule locale application on the microtask queue so we don't use
        // the incoming BuildContext inside an async callback.
        final uid = user.uid;
        _userService
            .getLocaleForUser(uid)
            .then((locale) {
              if (locale != null && locale.isNotEmpty) {
                // schedule on microtask to ensure context is still valid
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  MyApp.setLocale(context, Locale(locale));
                });
              }
            })
            .catchError((_) {});

        return const HomePage();
      },
    );
  }
}
