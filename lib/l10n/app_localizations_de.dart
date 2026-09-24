// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Calmdrop';

  @override
  String get tagline => 'Finde deine innere Ruhe.';

  @override
  String get intro =>
      'Sag oder schreib, was dir gerade durch den Kopf geht. Ein Gedanke pro Zeile — den Rest sortiert die App.';

  @override
  String get captureHint =>
      'z. B. Zahnarzttermin für Mia vereinbaren\nSteuererklärung anfangen\nMilch, Klopapier, Kaffee';

  @override
  String get addButton => 'Ablegen';

  @override
  String get listening => 'Ich höre zu … nochmal tippen zum Stoppen';

  @override
  String get micTooltip => 'Spracheingabe';

  @override
  String get speechUnavailable =>
      'Spracherkennung nicht verfügbar. Bitte Mikrofon-Zugriff in den Einstellungen erlauben.';

  @override
  String get emptyState =>
      'Noch nichts abgelegt. Schreib oder sprich oben rein, was dich beschäftigt.';

  @override
  String get allDone => 'Alles erledigt. Kopf ist frei.';

  @override
  String showDone(int count) {
    return 'Erledigt anzeigen ($count)';
  }

  @override
  String hideDone(int count) {
    return 'Erledigt ausblenden ($count)';
  }

  @override
  String get deleteTooltip => 'Löschen';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Systemsprache';

  @override
  String get categoryAppointments => 'Termine';

  @override
  String get categoryFamily => 'Familie & Kinder';

  @override
  String get categoryHousehold => 'Haushalt';

  @override
  String get categoryWork => 'Arbeit';

  @override
  String get categoryAdmin => 'Behörden & Papierkram';

  @override
  String get categoryOther => 'Sonstiges';

  @override
  String get info => 'Info';

  @override
  String get privacyPolicy => 'Datenschutz';

  @override
  String get support => 'Support';

  @override
  String get legalNotice => 'Impressum';

  @override
  String get licenses => 'Lizenzen';
}
