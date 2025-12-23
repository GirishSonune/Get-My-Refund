import 'package:get_my_refund/services/auth_service.dart'; // Import AuthService
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:get_my_refund/ui/about_us.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              onTap: () {
                MyApp.setLocale(context, const Locale('en'));
                Navigator.pop(context); // close sheet
                Navigator.pop(context); // close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('हिन्दी'),
              onTap: () {
                MyApp.setLocale(context, const Locale('hi'));
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Use asset if available, otherwise show a fallback icon
                  Builder(
                    builder: (ctx) {
                      try {
                        return Image.asset(
                          'avatar.png',
                          fit: BoxFit.contain,
                          height: 50,
                        );
                      } catch (_) {
                        return const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.grey,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Version 1.0',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.track_changes),
            title: const Text('Track Status'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/tracking');
            },
          ),
          ListTile(
            leading: const Icon(Icons.note_alt_outlined),
            title: const Text('Submit Complaint'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/complaint');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Lang'),
            onTap: () => _showLanguageSheet(context),
          ),
          ListTile(
            leading: const Icon(Icons.person_remove),
            title: const Text('Sign Out'),
            onTap: () async {
              final navigator = Navigator.of(context);
              await AuthService().signOut();
              navigator.pushNamedAndRemoveUntil('/', (_) => false);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact us'),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => ContactUsPage(),
            //     ),
            //   );
            // },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUs()),
              );
            },
          ),
        ],
      ),
    );
  }
}
