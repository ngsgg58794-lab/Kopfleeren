import 'package:calmdrop/services/transcript_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('iOS-Neustart nach Pause: vorheriger Abschnitt wird eigene Zeile', () {
    final t = TranscriptBuilder();
    for (final partial in [
      'Zahnarzt',
      'Zahnarzttermin',
      'Zahnarzttermin machen'
    ]) {
      t.add(partial, isFinal: false);
    }
    // Pause → iOS fängt neu an
    t.add('Bananen', isFinal: false);
    t.add('Bananen kaufen', isFinal: false);
    t.add('Tina', isFinal: false);
    t.add('Tina anrufen', isFinal: true);
    expect(t.text, 'Zahnarzttermin machen\nBananen kaufen\nTina anrufen');
  });

  test('Text verschwindet nicht, wenn iOS leer neu beginnt', () {
    final t = TranscriptBuilder();
    t.add('Zahnarzttermin Bananen kaufen', isFinal: false);
    t.add('', isFinal: false);
    expect(t.text, 'Zahnarzttermin Bananen kaufen');
  });

  test('Korrekturen der Erkennung erzeugen keine neue Zeile', () {
    final t = TranscriptBuilder();
    t.add('Zahnarzt Termin', isFinal: false);
    t.add('Zahnarzttermin', isFinal: false);
    t.add('Zahnarzttermin vereinbaren', isFinal: true);
    expect(t.text, 'Zahnarzttermin vereinbaren');
  });

  test('Satzzeichen trennen Gedanken, Listen mit Komma bleiben zusammen', () {
    final t = TranscriptBuilder();
    t.add(
        'Zahnarzttermin machen. Milch, Klopapier, Kaffee kaufen. '
        'Hat Tina angerufen?',
        isFinal: true);
    expect(t.text,
        'Zahnarzttermin machen\nMilch, Klopapier, Kaffee kaufen\nHat Tina angerufen?');
  });

  test('bestehender Text im Feld bleibt erhalten', () {
    final t = TranscriptBuilder('Wäsche waschen\n');
    t.add('müll rausbringen', isFinal: true);
    expect(t.text, 'Wäsche waschen\nMüll rausbringen');
  });
}
