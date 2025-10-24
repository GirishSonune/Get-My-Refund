import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get_my_refund/l10n/app_localizations.dart';
import 'package:get_my_refund/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'ui/complaint_page.dart';
import 'ui/splash_screen.dart';
import 'ui/auth_gate.dart';
import 'ui/login_page.dart';
import 'ui/signup_page.dart';
import 'ui/home_page.dart';
import 'ui/tracking_page.dart';
import 'ui/user_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider())],
      child: MyApp(key: MyApp._appKey),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<_MyAppState> _appKey = GlobalKey<_MyAppState>();
  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.updateLocale(locale);
  }

  /// Set locale using the global app key (doesn't require a BuildContext).
  static void setLocaleGlobal(Locale locale) {
    _appKey.currentState?.updateLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  void updateLocale(Locale locale) => setState(() => _locale = locale);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get My Refund',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6B81)),
        useMaterial3: true,
      ),

      // theme: Provider.of<ThemeProvider>(context).themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      locale: _locale,
      // Use AuthGate as the home so the UI follows Firebase auth state
      // across app restarts and resumes.
      home: const AuthGate(),
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignUpPage(),
        '/profile': (_) => const UserProfilePage(),
        '/home': (_) => const HomePage(),
        '/complaint': (_) => const ComplaintPage(),
        '/tracking': (_) => const TrackingPage(),
      },
    );
  }
}
