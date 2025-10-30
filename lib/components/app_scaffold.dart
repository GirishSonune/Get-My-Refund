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
  final Widget? drawer;
  final int? currentIndex;

  const AppScaffold({
    super.key,
    required this.body,
    this.title = '',
    this.onRaiseComplaint,
    this.drawer,
    this.currentIndex,
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
      drawer: drawer,
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed:
            onRaiseComplaint ??
            () => Navigator.pushNamed(context, '/complaint'),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.home,
              label: 'Home',
              isSelected: currentIndex == 0,
              onTap: () {
                if (currentIndex != 0) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                }
              },
            ),
            _NavBarItem(
              icon: Icons.track_changes,
              label: 'Track',
              isSelected: currentIndex == 1,
              onTap: () {
                if (currentIndex != 1) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/tracking',
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(width: 32), // Space for FAB
            _NavBarItem(
              icon: Icons.person,
              label: 'Profile',
              isSelected: currentIndex == 2,
              onTap: () {
                if (currentIndex != 2) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/profile',
                    (route) => false,
                  );
                }
              },
            ),
            _NavBarItem(
              icon: Icons.info_outline,
              label: 'About',
              isSelected: currentIndex == 3,
              onTap: () {
                if (currentIndex != 3) {
                  Navigator.pushNamed(context, '/about_us');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;

  const _NavBarItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.colorScheme.primary : Colors.grey;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontSize: 12)),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
