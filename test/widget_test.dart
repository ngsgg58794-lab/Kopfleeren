import 'package:flutter_test/flutter_test.dart';
import 'package:kopf_leeren/services/categorizer.dart';

void main() {
  test('Termine werden erkannt', () {
    expect(categorize('Zahnarzttermin für Mia vereinbaren'), 'termine');
  });

  test('Unbekanntes landet in Sonstiges', () {
    expect(categorize('xyz'), 'sonstiges');
    expect(categorize(''), 'sonstiges');
  });
}
