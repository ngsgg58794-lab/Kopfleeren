// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Calmdrop';

  @override
  String get tagline => 'Find your inner calm.';

  @override
  String get intro =>
      'Say or type whatever is on your mind. One thought per line — the app sorts the rest.';

  @override
  String get captureHint =>
      'e.g. Book a dentist appointment for Mia\nStart on the tax return\nMilk, toilet paper, coffee';

  @override
  String get addButton => 'Add';

  @override
  String get listening => 'Listening … tap again to stop';

  @override
  String get micTooltip => 'Voice input';

  @override
  String get speechUnavailable =>
      'Speech recognition unavailable. Please allow microphone access in Settings.';

  @override
  String get emptyState =>
      'Nothing here yet. Type or speak above whatever is on your mind.';

  @override
  String get allDone => 'All done. Your mind is clear.';

  @override
  String showDone(int count) {
    return 'Show completed ($count)';
  }

  @override
  String hideDone(int count) {
    return 'Hide completed ($count)';
  }

  @override
  String get deleteTooltip => 'Delete';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get categoryAppointments => 'Appointments';

  @override
  String get categoryFamily => 'Family & kids';

  @override
  String get categoryHousehold => 'Household';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryAdmin => 'Paperwork & admin';

  @override
  String get categoryOther => 'Other';

  @override
  String get info => 'Info';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get support => 'Support';

  @override
  String get legalNotice => 'Legal notice';

  @override
  String get licenses => 'Licenses';
}
