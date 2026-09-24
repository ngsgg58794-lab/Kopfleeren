# Kopf leeren — Flutter-App

Flutter-App (iOS + Android). Plattform-Projekte sind generiert, Berechtigungen
und App-Icon sind eingetragen.

## Entwickeln

```
flutter pub get
flutter run
flutter analyze && flutter test
```

## Bereits erledigt

- iOS `Info.plist`: `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`,
  `ITSAppUsesNonExemptEncryption = false` (spart die Export-Compliance-Frage),
  Anzeigename „Kopf leeren“, Entwicklungssprache `de`
- Android `AndroidManifest.xml`: `RECORD_AUDIO`, `INTERNET`, `<queries>` für
  `android.speech.RecognitionService` (sonst findet `speech_to_text` auf Android 11+
  keinen Erkenner), Label „Kopf leeren“
- `minSdk` kommt von Flutter (aktuell ≥ 21, reicht für `speech_to_text`)
- App-Icon: Quelle `assets/icon/icon.svg`, erzeugt mit `flutter_launcher_icons`.
  Nach Änderungen: PNGs neu rendern, dann `dart run flutter_launcher_icons`
- Mikrofon-Berechtigung wird erst beim Tippen aufs Mikrofon angefragt, nicht beim Start

## Vor dem Store-Upload (manuell)

1. **Bundle-ID / Application-ID** prüfen: aktuell `de.kopfleeren.kopfLeeren` (iOS) bzw.
   `de.kopfleeren.kopf_leeren` (Android). Nach dem ersten Upload nicht mehr änderbar.
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
4. **Datenschutzerklärung (Pflicht in beiden Stores):** muss erwähnen, dass
   - Spracheingaben zur Erkennung an Apple bzw. Google übertragen werden können,
   - `google_fonts` die Schriften zur Laufzeit von Google-Servern lädt (IP-Übertragung,
     DSGVO-relevant). Alternative: Fonts als Assets bündeln und
     `GoogleFonts.config.allowRuntimeFetching = false` setzen.
5. **Store-Angaben:** Play „Datensicherheit“ + Apple „App-Datenschutz“ (Audio-Daten),
   Screenshots, Beschreibung, Altersfreigabe-Fragebogen.
6. Version in `pubspec.yaml` (`version: 1.0.0+1`) vor jedem Upload erhöhen.

## Was drinsteckt

- `lib/models/task.dart` — Datenmodell
- `lib/services/categorizer.dart` — Keyword-basierte Auto-Kategorisierung
  (dieselbe Logik wie in der Web-Version)
- `lib/services/storage_service.dart` — lokale Persistenz (`shared_preferences`)
- `lib/services/speech_service.dart` — native Spracherkennung
  (`speech_to_text`, nutzt iOS `SFSpeechRecognizer` / Android `SpeechRecognizer`
  statt der unzuverlässigen Web Speech API)
- `lib/screens/home_screen.dart` — UI: Erfassung, Mikrofon, gruppierte Liste,
  Erledigt-Bereich
- `lib/main.dart` — Theme (an die Web-Version angelehnte Farben, Fraunces +
  Inter via `google_fonts`)

## Bekannte Lücken

- Kein Undo beim Löschen einer Aufgabe
- Kein Haptic-Feedback beim Abhaken
- Keine iCloud/Cloud-Synchronisation — Daten liegen nur lokal auf dem Gerät
- Splash-Screen ist noch der Flutter-Standard (weißer Hintergrund)
