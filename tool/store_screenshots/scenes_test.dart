// Rendert die App-Szenen für die Store-Screenshots (Demo-Daten, DE + EN).
// Aufruf siehe tool/store_screenshots/README.md
// Liegt bewusst außerhalb von test/, damit `flutter test` es nicht mitlaufen lässt.
// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:io';
import 'dart:ui' as ui;

import 'package:calmdrop/main.dart';
import 'package:calmdrop/services/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _font(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final p in paths) {
    loader
        .addFont(Future.value(ByteData.sublistView(File(p).readAsBytesSync())));
  }
  await loader.load();
}

const _out = 'build/store_raw';

const _voiceText = {
  'de': 'Geschenk für Papa besorgen\nAuto zum TÜV bringen',
  'en': 'Get a present for dad\nTake the car for its inspection',
};

void main() {
  setUpAll(() async {
    final flutterRoot = Platform.environment['FLUTTER_ROOT']!;
    await _font('Inter', [
      'assets/fonts/Inter-Regular.ttf',
      'assets/fonts/Inter-SemiBold.ttf',
    ]);
    await _font('MaterialIcons', [
      '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    ]);
    Directory(_out).createSync(recursive: true);
  });

  for (final lang in ['de', 'en']) {
    for (final scene in ['list', 'voice', 'sorted', 'dark', 'language']) {
      testWidgets('$lang $scene', (tester) async {
        // iPhone 16 Pro Max: 440×956 pt @3x
        tester.view.physicalSize = const Size(1320, 2868);
        tester.view.devicePixelRatio = 3;
        const insets = FakeViewPadding(top: 62 * 3, bottom: 34 * 3);
        tester.view.padding = insets;
        tester.view.viewPadding = insets;
        tester.platformDispatcher.platformBrightnessTestValue =
            scene == 'dark' ? Brightness.dark : Brightness.light;
        // Sprach-Plugin simulieren, damit der Mikrofon-Zustand sichtbar ist.
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('plugin.csdcorp.com/speech_to_text'),
          (call) async => call.method == 'locales' ? <String>[] : true,
        );
        SharedPreferences.setMockInitialValues({'app_locale': lang});
        final controller = LocaleController();
        await controller.load();
        final key = GlobalKey();
        await tester.pumpWidget(RepaintBoundary(
          key: key,
          child: CalmdropApp(localeController: controller),
        ));
        await tester.pump(const Duration(seconds: 3)); // Splash
        await tester.pumpAndSettle();

        final scroll = find.byType(SingleChildScrollView);
        switch (scene) {
          case 'voice':
            await tester.enterText(find.byType(TextField), _voiceText[lang]!);
            await tester.tap(find.byIcon(Icons.mic));
            await tester.pump(const Duration(milliseconds: 300));
            FocusManager.instance.primaryFocus?.unfocus();
            await tester.pump(const Duration(milliseconds: 300));
          case 'sorted':
            await tester.drag(scroll, const Offset(0, -3000));
            await tester.pumpAndSettle();
            await tester.tap(find.textContaining(
                lang == 'de' ? 'Erledigt anzeigen' : 'Show completed'));
            await tester.pumpAndSettle();
            await tester.drag(scroll, const Offset(0, -3000));
            await tester.pumpAndSettle();
          case 'language':
            await tester.tap(find.byIcon(Icons.translate));
            await tester.pumpAndSettle();
        }

        await tester.runAsync(() async {
          final boundary =
              key.currentContext!.findRenderObject() as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 3);
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          File('$_out/${lang}_$scene.png')
              .writeAsBytesSync(png!.buffer.asUint8List());
        });
        if (scene == 'voice') {
          // Aufnahme beenden, damit kein Timer des Plugins offen bleibt.
          await tester.tap(find.byIcon(Icons.mic));
          await tester.pump(const Duration(seconds: 3));
          await tester.pumpAndSettle();
        }
      });
    }
  }
}
