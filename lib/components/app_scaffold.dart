import 'package:flutter/material.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

/// AppScaffold provides a consistent app bar with language toggle and
/// a persistent floating action button for raising complaints.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final VoidCallback? onRaiseComplaint;
  final Widget? drawer; // <-- 1. ADD THIS LINE

  const AppScaffold({
    super.key,
    required this.body,
    this.title = '',
    this.onRaiseComplaint,
    this.drawer, // <-- 2. ADD THIS LINE
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title.isEmpty ? 'Get My Refund' : title),
        actions: [
          // Locale toggle (quick)
          PopupMenuButton<String>(
            onSelected: (v) {
              // Apply immediately on the next frame to avoid using the
              // incoming BuildContext across asynchronous callbacks.
              MyApp.setLocaleGlobal(Locale(v));
              // If user is signed in, persist preference to Firestore (fire-and-forget)
              final user = AuthService().currentUser;
              if (user != null) {
                UserService().setLocaleForUser(user.uid, v).catchError((_) {});
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'hi', child: Text('हिन्दी')),
            ],
            icon: const Icon(Icons.language),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'signout', child: Text('Sign out')),
            ],
            onSelected: (v) {
              if (v == 'signout') {
                // Fire sign out (best-effort) and navigate immediately to avoid
                // using the BuildContext inside an async callback.
                AuthService().signOutAll().catchError((_) {});
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (_) => false,
                );
                return;
              }
              if (v == 'profile') {
                Navigator.pushNamed(context, '/profile');
              }
            },
          ),
        ],
      ),
      drawer: drawer, // <-- 3. ADD THIS LINE
      body: body,
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            onRaiseComplaint ??
            () => Navigator.pushNamed(context, '/complaint'),
        label: const Text('Raise a New Complaint'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
