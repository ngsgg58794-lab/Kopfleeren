import '../l10n/app_localizations.dart';

class TaskCategory {
  final String id;

  /// Deutsch: Teilwort-Treffer (Komposita wie „Zahnarzttermin“). Kurzwörter
  /// (≤ 3 Zeichen) nur am Wortanfang, sonst trifft „oma“ auch „Tomaten“.
  final List<String> de;

  /// Englisch: nur ganze Wörter (optional mit Plural-s), damit z. B. „son“
  /// nicht in „person“ anschlägt.
  final List<String> en;

  const TaskCategory(this.id, {this.de = const [], this.en = const []});
}

const List<TaskCategory> categories = [
  TaskCategory('termine', de: [
    'termin', 'arzt', 'ärztin', 'zahnarzt', 'friseur', 'tüv', 'anruf', //
    'anrufen', 'rückruf', 'meeting', 'treffen', 'geburtstag',
  ], en: [
    'appointment', 'doctor', 'dentist', 'haircut', 'hairdresser', 'call', //
    'meeting', 'birthday', 'checkup', 'vet',
  ]),
  TaskCategory('familie', de: [
    'kind', 'kita', 'schule', 'baby', 'sohn', 'tochter', 'eltern', 'oma', //
    'opa',
  ], en: [
    'kid', 'child', 'children', 'daycare', 'school', 'baby', 'son', //
    'daughter', 'parent', 'grandma', 'grandpa', 'mom', 'mum', 'dad',
  ]),
  TaskCategory('haushalt', de: [
    'putzen', 'wäsche', 'waschen', 'kochen', 'müll', 'einkaufen', 'einkauf', //
    'milch', 'klopapier', 'kaffee', 'staubsaugen', 'bügeln', 'spülen',
  ], en: [
    'clean', 'laundry', 'wash', 'cook', 'trash', 'garbage', 'groceries', //
    'grocery', 'shopping', 'milk', 'toilet paper', 'coffee', 'vacuum',
    'dishes', 'ironing',
  ]),
  TaskCategory('arbeit', de: [
    'mail', 'e-mail', 'projekt', 'deadline', 'kunde', 'rechnung', //
    'präsentation', 'bericht', 'chef', 'kollege',
  ], en: [
    'email', 'e-mail', 'mail', 'project', 'deadline', 'client', 'customer', //
    'invoice', 'presentation', 'report', 'boss', 'colleague',
  ]),
  TaskCategory('admin', de: [
    'steuer', 'versicherung', 'antrag', 'formular', 'amt', 'finanzamt',
    'bürgeramt', 'bank', //
    'überweisung', 'vertrag', 'kündigen',
  ], en: [
    'tax', 'taxes', 'insurance', 'application', 'form', 'bank', 'transfer', //
    'contract', 'cancel', 'passport', 'visa',
  ]),
  TaskCategory('sonstiges'),
];

const _letter = 'a-zäöüß';

final Map<String, RegExp> _dePatterns = {
  for (final c in categories)
    for (final k in c.de)
      k: k.length <= 3
          ? RegExp('(^|[^$_letter])${RegExp.escape(k)}')
          : RegExp(RegExp.escape(k)),
};

final Map<String, RegExp> _enPatterns = {
  for (final c in categories)
    for (final k in c.en)
      k: RegExp('(^|[^$_letter])${RegExp.escape(k)}(s|es)?(\$|[^$_letter])'),
};

String categorize(String text) {
  final lower = text.toLowerCase();
  for (final cat in categories) {
    if (cat.de.any((k) => _dePatterns[k]!.hasMatch(lower)) ||
        cat.en.any((k) => _enPatterns[k]!.hasMatch(lower))) {
      return cat.id;
    }
  }
  return 'sonstiges';
}

String labelFor(AppLocalizations l10n, String categoryId) =>
    switch (categoryId) {
      'termine' => l10n.categoryAppointments,
      'familie' => l10n.categoryFamily,
      'haushalt' => l10n.categoryHousehold,
      'arbeit' => l10n.categoryWork,
      'admin' => l10n.categoryAdmin,
      _ => l10n.categoryOther,
    };
