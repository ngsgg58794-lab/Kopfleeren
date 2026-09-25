import '../models/task.dart';
import 'categorizer.dart';

/// Demo-Modus für Store-Screenshots: `flutter run --dart-define=DEMO=true`.
/// Zeigt Beispiel-Einträge in der App-Sprache und speichert nichts.
const bool demoMode = bool.fromEnvironment('DEMO');

const _open = {
  'de': [
    'Zahnarzttermin für Mia vereinbaren',
    'Oma zum Geburtstag anrufen',
    'Elternabend in der Kita',
    'Milch, Klopapier, Kaffee',
    'Wäsche waschen',
    'Präsentation für Montag fertig machen',
    'E-Mail an Kunden beantworten',
    'Steuererklärung anfangen',
    'Kfz-Versicherung vergleichen',
    'Laufschuhe kaufen',
  ],
  'en': [
    'Book a dentist appointment for Mia',
    'Call grandma for her birthday',
    'Parent evening at daycare',
    'Milk, toilet paper, coffee',
    'Do the laundry',
    'Finish the presentation for Monday',
    'Reply to the client email',
    'Start on the tax return',
    'Compare car insurance',
    'Buy new running shoes',
  ],
};

const _done = {
  'de': ['Müll rausbringen', 'Rückruf Physiotherapie'],
  'en': ['Take out the trash', 'Call back the physio'],
};

List<Task> demoTasks(String languageCode) {
  final lang = languageCode == 'de' ? 'de' : 'en';
  var i = 0;
  Task make(String text, bool done) => Task(
        id: 'demo-${i++}',
        text: text,
        category: categorize(text),
        done: done,
      );
  return [
    for (final t in _open[lang]!) make(t, false),
    for (final t in _done[lang]!) make(t, true),
  ];
}
