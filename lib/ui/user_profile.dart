import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../main.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _userService = UserService();
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  bool _loading = true;
  String _selectedLocale = 'en';
  bool _redirectToLogin = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    final uid = user?.uid;
    if (uid == null) {
      // no logged in user, mark for redirect and return; navigation will be
      // handled from build() to avoid using BuildContext across async gaps.
      if (mounted) {
        setState(() {
          _redirectToLogin = true;
        });
      }
      return;
    }
    final p = await _userService.getUserProfile(uid);
    if (p != null) {
      _nameCtrl.text = (p['name'] ?? '') as String;
      _mobileCtrl.text = (p['mobile'] ?? '') as String;
      _emailCtrl.text = (p['email'] ?? '') as String;
      _selectedLocale = (p['locale'] ?? 'en') as String;
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final user = _auth.currentUser;
    final uid = user?.uid;
    if (uid == null) return;
    await _userService.setUserProfile(
      uid,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      locale: _selectedLocale,
    );
    await _userService.setLocaleForUser(uid, _selectedLocale);
    if (mounted) {
      MyApp.setLocaleGlobal(Locale(_selectedLocale));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Profile updated')));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_redirectToLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
      });
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Full name'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Please enter name'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _mobileCtrl,
                      decoration: const InputDecoration(labelText: 'Mobile'),
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Please enter mobile'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Language:'),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedLocale,
                          items: const [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('English'),
                            ),
                            DropdownMenuItem(
                              value: 'hi',
                              child: Text('हिन्दी'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _selectedLocale = v);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _saveProfile,
                          icon: const Icon(Icons.save),
                          label: const Text('Save'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await _auth.signOutAll();
                            if (mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (_) => false,
                              );
                            }
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Sign out'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
