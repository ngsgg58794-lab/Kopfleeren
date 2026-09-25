import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calmdrop/main.dart';
import 'package:calmdrop/services/categorizer.dart';
import 'package:calmdrop/services/demo_data.dart';
import 'package:calmdrop/services/locale_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('categorize', () {
    test('Deutsch', () {
      expect(categorize('Zahnarzttermin für Mia vereinbaren'), 'termine');
      expect(categorize('Steuererklärung anfangen'), 'admin');
      expect(categorize('Milch, Klopapier, Kaffee'), 'haushalt');
      expect(categorize('Oma anrufen'), 'termine');
      expect(categorize('Brief ans Finanzamt'), 'admin');
    });

    test('Englisch', () {
      expect(categorize('Book a dentist appointment for Mia'), 'termine');
      expect(categorize('Start on the taxes'), 'admin');
      expect(categorize('Milk, toilet paper, coffee'), 'haushalt');
      expect(categorize('Email the client'), 'arbeit');
      expect(categorize('Pick up the kids'), 'familie');
    });

    test('keine Teilwort-Fehltreffer', () {
      expect(categorize('Tomaten'), 'sonstiges'); // „oma“
      expect(categorize('Gesamtbild überdenken'), 'sonstiges'); // „amt“
      expect(categorize('Ask that person'), 'sonstiges'); // „son“
      expect(categorize('Wait a moment'), 'sonstiges'); // „mom“
    });

    test('Unbekanntes landet in Sonstiges', () {
      expect(categorize('xyz'), 'sonstiges');
      expect(categorize(''), 'sonstiges');
    });
  });

  testWidgets('Sprachwechsel in der App', (tester) async {
    SharedPreferences.setMockInitialValues({'app_locale': 'de'});
    final controller = LocaleController();
    await controller.load();
    await tester.pumpWidget(CalmdropApp(localeController: controller));
    await tester.pump(const Duration(seconds: 3)); // Splash
    await tester.pumpAndSettle();

    expect(find.text('Ablegen'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.translate));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Add'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app_locale'), 'en');
  });

  test('Demo-Daten decken alle Kategorien ab (DE + EN)', () {
    for (final lang in ['de', 'en']) {
      final tasks = demoTasks(lang);
      expect(
        tasks.where((t) => !t.done).map((t) => t.category).toSet(),
        {'termine', 'familie', 'haushalt', 'arbeit', 'admin', 'sonstiges'},
        reason: lang,
      );
      expect(tasks.where((t) => t.done), hasLength(2));
    }
  });
}
