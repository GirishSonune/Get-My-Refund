// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get submitTitle => 'SUBMIT YOUR COMPLAINT';

  @override
  String get enterName => 'Name';

  @override
  String get enterPhone => 'Phone';

  @override
  String get enterEmail => 'Email';

  @override
  String get issueLabel => 'Your issue with the company/brand';

  @override
  String get docsLabel => 'Documents to support Complaint';

  @override
  String get attachments => 'Attachments';

  @override
  String get agreeTerms => 'I agree to the terms & conditions listed below';

  @override
  String get send => 'SEND';
}
