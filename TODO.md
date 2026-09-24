# Offene Schritte bis zum Store-Upload

## 1. Website einschalten (2 Min.)
- [ ] GitHub → Repo → *Settings → Pages* → *Deploy from a branch*
      → Branch `claude/app-store-playstore-prep-drupfr`, Ordner `/docs` → *Save*
- [ ] Nach ein paar Minuten prüfen:
  - Support: https://ngsgg58794-lab.github.io/Kopfleeren/
  - Datenschutz: https://ngsgg58794-lab.github.io/Kopfleeren/privacy.html
  - Impressum: https://ngsgg58794-lab.github.io/Kopfleeren/impressum.html
- [ ] Datenschutzerklärung rechtlich prüfen lassen (Entwurf, keine Rechtsberatung)

## 2. Name sichern
- [ ] „Calmdrop“ in App Store Connect und Play Console anlegen/reservieren
- [ ] Markenrecherche DPMA/EUIPO

## 3. Screenshots
**iPhone (Mac mit Xcode):**
1. `open -a Simulator` → *File → Open Simulator → iPhone 16 Pro Max* (Pflichtgröße 6,9")
2. Im Projektordner: `flutter run`
3. Beispiel-Gedanken eingeben, sodass mehrere Kategorien gefüllt sind
4. **⌘ + S** → Bild liegt auf dem Schreibtisch
5. Sprache in der App umstellen (Übersetzen-Symbol) → dieselben Bilder auf Englisch
6. Dunkelmodus: **⇧⌘A**

**Android (Android Studio):**
1. *Device Manager* → Pixel 8 anlegen, starten, `flutter run`
2. Kamera-Symbol im Emulator-Menü. Mind. 2 Bilder + Feature-Grafik 1024×500

**Echtes iPhone:** Pro Max oder Plus → Seitentaste + Lauter

**Optik:** Previewed oder AppMockUp – Überschriften stehen in `fastlane/STORE.md`

## 4. Signieren & hochladen
- [ ] Android: Upload-Keystore + `android/key.properties` (siehe README), `flutter build appbundle`
- [ ] iOS: Team in Xcode wählen, `flutter build ipa`, Upload per Transporter
- [ ] Texte aus `fastlane/metadata/` und Datenschutz-Antworten aus `fastlane/STORE.md` eintragen

## Offene Frage an Claude
- Demo-Modus (`flutter run --dart-define=DEMO=true`) mit Beispiel-Einträgen für Screenshots?
