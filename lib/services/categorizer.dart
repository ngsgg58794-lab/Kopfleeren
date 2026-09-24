class TaskCategory {
  final String id;
  final String label;
  final List<String> keywords;
  const TaskCategory(this.id, this.label, this.keywords);
}

const List<TaskCategory> categories = [
  TaskCategory('termine', 'Termine', [
    'termin',
    'arzt',
    'ärztin',
    'zahnarzt',
    'friseur',
    'tüv',
    'anruf',
    'anrufen',
    'rückruf',
    'meeting',
    'treffen',
    'geburtstag',
  ]),
  TaskCategory('familie', 'Familie & Kinder', [
    'kind',
    'kita',
    'schule',
    'baby',
    'sohn',
    'tochter',
    'eltern',
    'oma',
    'opa',
  ]),
  TaskCategory('haushalt', 'Haushalt', [
    'putzen',
    'wäsche',
    'waschen',
    'kochen',
    'müll',
    'einkaufen',
    'einkauf',
    'milch',
    'klopapier',
    'kaffee',
    'staubsaugen',
    'bügeln',
    'spülen',
  ]),
  TaskCategory('arbeit', 'Arbeit', [
    'mail',
    'e-mail',
    'projekt',
    'deadline',
    'kunde',
    'rechnung',
    'präsentation',
    'bericht',
    'chef',
    'kollege',
  ]),
  TaskCategory('admin', 'Behörden & Papierkram', [
    'steuer',
    'versicherung',
    'antrag',
    'formular',
    'amt',
    'bank',
    'überweisung',
    'vertrag',
    'kündigen',
  ]),
  TaskCategory('sonstiges', 'Sonstiges', []),
];

String categorize(String text) {
  final lower = text.toLowerCase();
  for (final cat in categories) {
    if (cat.id == 'sonstiges') continue;
    if (cat.keywords.any((k) => lower.contains(k))) return cat.id;
  }
  return 'sonstiges';
}

String labelFor(String categoryId) => categories
    .firstWhere((c) => c.id == categoryId, orElse: () => categories.last)
    .label;
