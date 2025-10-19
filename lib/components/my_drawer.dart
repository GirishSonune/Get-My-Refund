import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import 'package:get_my_refund/services/auth_service.dart';
import '../main.dart';
import 'package:get_my_refund/ui/about_us.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
                Navigator.pop(context); // close sheet
                Navigator.pop(context); // close drawer
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // drawer header logo
              const SizedBox(height: 25),

              DrawerHeader(
                child: Container(
                  // width: double.infinity,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/profile_page',
                          (route) => false,
                        ),
                        child: const CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage("avatar.png"),
                        ),
                      ),
                      // SizedBox(
                      //   height: 12,
                      // ),
                      const Text(
                        "Hello, Girish",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      // Text("girish.sonune"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Home (From new file)
              MyListTile(
                text: "Home",
                icon: Icons.home,
                onTap: () => Navigator.pop(context),
              ),

              // Track Status (From old file)
              MyListTile(
                text: "Track Status",
                icon: Icons.track_changes,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/tracking');
                },
              ),

              // Submit Complaint (From old file)
              MyListTile(
                text: "Submit Complaint",
                icon: Icons.note_alt_outlined,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/complaint');
                },
              ),

              // About Us (Combined: UI from new, logic from old)
              MyListTile(
                text: "About Us",
                icon: Icons.info, // Icon from old file
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutUs()),
                  );
                },
              ),

              // Contact Us (From new file, but with standard push navigation)
              MyListTile(
                text: "Contact Us",
                icon: Icons.contact_mail, // Icon from old file
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/contact_us');
                },
              ),

              // Language (From old file)
              MyListTile(
                text: "Language", // Renamed from "Lang" for clarity
                icon: Icons.language,
                onTap: () => _showLanguageSheet(context),
              ),

              // Sign Out (From old file)
              // This replaces "Log In", "Register", and "Exit" from the new file,
              // as this drawer seems intended for a logged-in user ("Hello, Girish").
              MyListTile(
                text: "Sign Out",
                icon: Icons.person_remove,
                onTap: () {
                  AuthService().signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (_) => false,
                    );
                  }
                },
              ),
            ],
          ),

          // Theme (From new file)
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              text: "Change Theme",
              icon: Icons.dark_mode_outlined,
              onTap: () => Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleTheme(),
            ),
          ),
        ],
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onTap;
  const MyListTile({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
        ),
        onTap: onTap,
      ),
    );
  }
}
