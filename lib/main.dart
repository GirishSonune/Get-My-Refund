import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get_my_refund/l10n/app_localizations.dart';
import 'package:get_my_refund/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'ui/about_us.dart';
import 'ui/complaint_page.dart';
import 'ui/contact_us.dart';
import 'ui/details_page.dart';
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
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final systemLocale = View.of(context).platformDispatcher.locale;
      final supportedLocales = [const Locale('en'), const Locale('hi')];

      setState(() {
        _locale = supportedLocales.contains(systemLocale)
            ? systemLocale
            : const Locale('en');
      });
    } catch (e) {
      setState(() => _locale = const Locale('en'));
    }
  }

  void updateLocale(Locale locale) {
    if (locale.languageCode != _locale.languageCode) {
      setState(() => _locale = locale);
      Navigator.pop(context); // Close drawer after language change
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: 'Get My Refund',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9CD6B8)),
        useMaterial3: true,
      ),

      // theme: Provider.of<ThemeProvider>(context).themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: const AuthGate(),
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignUpPage(),
        '/profile': (_) => const UserProfilePage(),
        '/home': (_) => const HomePage(),
        '/complaint': (_) => const ComplaintPage(),
        '/tracking': (_) => const TrackingPage(),
        '/contact_us': (_) => const ContactUsPage(),
        '/about_us': (_) => const AboutUs(),
        '/details': (_) => const DetailsPage(),
      },
    );
  }
}
