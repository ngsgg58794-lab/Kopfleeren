# Store-Screenshots neu erzeugen

```
flutter test --dart-define=DEMO=true tool/store_screenshots/scenes_test.dart
pip install pillow
python3 tool/store_screenshots/compose.py
```

1. Der Test rendert die App (Demo-Daten, DE/EN, 5 Szenen) nach `build/store_raw/`.
2. `compose.py` legt Hintergrund, Überschrift, iPhone-Rahmen und Statusleiste darüber:
   - App Store 6,9" (1320×2868) und 6,5" (1284×2778, `*_6.5.png`): `fastlane/screenshots/{de-DE,en-US}/`
   - Google Play (1080×1920): `fastlane/metadata/android/{de-DE,en-US}/images/phoneScreenshots/`
   - Play-Feature-Grafik (1024×500) und Icon (512×512): `.../images/`

Überschriften: Liste `SCENES` in `compose.py`.
