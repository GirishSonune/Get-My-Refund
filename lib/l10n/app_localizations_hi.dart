// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get submitTitle => 'शिकायत दर्ज करें';

  @override
  String get enterName => 'नाम';

  @override
  String get enterPhone => 'फ़ोन';

  @override
  String get enterEmail => 'ईमेल';

  @override
  String get issueLabel => 'कंपनी/ब्रांड के साथ आपकी समस्या';

  @override
  String get docsLabel => 'शिकायत के समर्थन में दस्तावेज़';

  @override
  String get attachments => 'संलग्नक';

  @override
  String get agreeTerms => 'मैं नीचे दिए गए नियमों और शर्तों से सहमत हूँ';

  @override
  String get send => 'भेजें';
}
