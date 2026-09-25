# Calmdrop — Finde deine innere Ruhe

Englisch: *Find your inner calm.*

Flutter-App (iOS + Android). Plattform-Projekte sind generiert, Berechtigungen
und App-Icon sind eingetragen.

## Entwickeln

```
flutter pub get
flutter run
flutter analyze && flutter test

# Screenshots: Beispiel-Einträge in der App-Sprache, speichert nichts
flutter run --dart-define=DEMO=true
```

## Bereits erledigt

- iOS `Info.plist`: `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`,
  `ITSAppUsesNonExemptEncryption = false` (spart die Export-Compliance-Frage),
  Anzeigename „Calmdrop“, Sprachen `en` (Basis) + `de` (`CFBundleLocalizations`),
  Berechtigungstexte übersetzt in `ios/Runner/{en,de}.lproj/InfoPlist.strings`
- Android `AndroidManifest.xml`: `RECORD_AUDIO`, `INTERNET`, `<queries>` für
  `android.speech.RecognitionService` (sonst findet `speech_to_text` auf Android 11+
  keinen Erkenner), Label „Calmdrop“, `localeConfig` (Android 13+: Sprache pro App)
- `minSdk` kommt von Flutter (aktuell ≥ 21, reicht für `speech_to_text`)
- App-Icon: Quelle `assets/icon/icon.svg`, erzeugt mit `flutter_launcher_icons`.
  Nach Änderungen: PNGs neu rendern, dann `dart run flutter_launcher_icons`
- Mikrofon-Berechtigung wird erst beim Tippen aufs Mikrofon angefragt, nicht beim Start

## Vor dem Store-Upload (manuell)

1. **Name + Bundle-ID sichern:** „Calmdrop“ in App Store Connect und Play Console
   reservieren (Namen müssen im App Store eindeutig sein). Markenrecherche (DPMA/EUIPO)
   ist Pflicht: „MindWave“ ist ein eingeführter Produktname von NeuroSky (EEG-Headsets).
   Bundle-/Application-ID: `com.calmdrop.app` – nach dem ersten Upload nicht mehr änderbar.
   Store-Untertitel (max. 30 Zeichen): DE „Finde deine innere Ruhe“, EN „Find your inner calm“.
2. **Android-Signing:** Upload-Keystore erzeugen
   ```
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   und `android/key.properties` anlegen (ist in `.gitignore`):
   ```
   storePassword=...
   keyPassword=...
   keyAlias=upload
   storeFile=/absoluter/pfad/upload-keystore.jks
   ```
   Build: `flutter build appbundle` → `build/app/outputs/bundle/release/app-release.aab`
3. **iOS-Signing:** `ios/Runner.xcworkspace` in Xcode öffnen, Team unter
   *Signing & Capabilities* wählen. Build: `flutter build ipa` → Upload per Transporter/Xcode.
4. **Website (Support, Datenschutz, Impressum) einschalten:** GitHub → Repo *Settings → Pages*
   → *Deploy from a branch* → Branch mit dem Ordner `/docs` wählen → *Save*.
   Danach erreichbar unter https://ngsgg58794-lab.github.io/Kopfleeren/
5. **Store-Angaben:** Play „Datensicherheit“ + Apple „App-Datenschutz“ (Audio-Daten),
   Screenshots, Altersfreigabe-Fragebogen. Texte, Datenschutz-Antworten und
   Screenshot-Plan: `fastlane/STORE.md`.
6. Version in `pubspec.yaml` (`version: 1.0.0+1`) vor jedem Upload erhöhen.

## Sprachen

Deutsch und Englisch, Auswahl in der App (Übersetzen-Symbol oben rechts:
Systemsprache / Deutsch / English, wird gespeichert).

- Texte: `lib/l10n/app_en.arb` (Vorlage) und `lib/l10n/app_de.arb`;
  nach Änderungen `flutter gen-l10n` (läuft auch automatisch bei `flutter run`)
- Kategorisierung erkennt deutsche und englische Stichwörter (`lib/services/categorizer.dart`)
- Spracherkennung folgt der App-Sprache (`de_DE` / `en_US`)

## Was drinsteckt

- `lib/models/task.dart` — Datenmodell
- `lib/services/categorizer.dart` — Keyword-basierte Auto-Kategorisierung (DE + EN)
- `lib/services/locale_controller.dart` — gewählte App-Sprache
- `lib/services/storage_service.dart` — lokale Persistenz (`shared_preferences`)
- `lib/services/speech_service.dart` — native Spracherkennung
  (`speech_to_text`, nutzt iOS `SFSpeechRecognizer` / Android `SpeechRecognizer`
  statt der unzuverlässigen Web Speech API)
- `lib/screens/home_screen.dart` — UI: Erfassung, Mikrofon, gruppierte Liste,
  Erledigt-Bereich
- `lib/main.dart` — Theme (Meeresblau/Weiß, Schrift Inter,
  gebündelt in `assets/fonts`, kein Nachladen aus dem Netz)

## Bekannte Lücken

- Kein Undo beim Löschen einer Aufgabe
- Kein Haptic-Feedback beim Abhaken
- Keine iCloud/Cloud-Synchronisation — Daten liegen nur lokal auf dem Gerät
- Nativer Splash ist statisch (iOS erlaubt keine Animation); animiert wird danach in `lib/screens/splash_screen.dart`
