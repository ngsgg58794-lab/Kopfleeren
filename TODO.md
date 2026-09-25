# Offene Schritte bis zum Store-Upload

## 1. Website einschalten ✅
- [x] GitHub → Repo → *Settings → Pages* → *Deploy from a branch*
      → Branch `claude/app-store-playstore-prep-drupfr`, Ordner `/docs` → *Save*
- [ ] Nach ein paar Minuten prüfen:
  - Support: https://ngsgg58794-lab.github.io/Kopfleeren/
  - Datenschutz: https://ngsgg58794-lab.github.io/Kopfleeren/privacy.html
  - Impressum: https://ngsgg58794-lab.github.io/Kopfleeren/impressum.html
- [ ] Datenschutzerklärung rechtlich prüfen lassen (Entwurf, keine Rechtsberatung)

## 2. Name sichern
- Bundle-ID: `de.juliawimmer.calmdrop` (`com.calmdrop.app` war bei Apple schon vergeben)
- [ ] „Calmdrop“ in App Store Connect und Play Console anlegen/reservieren
- [ ] Markenrecherche DPMA/EUIPO

## 3. Screenshots ✅
Fertig in `fastlane/screenshots/` (App Store) und `fastlane/metadata/android/*/images/`
(Play inkl. Feature-Grafik + 512er-Icon). Neu erzeugen: `tool/store_screenshots/README.md`.
- [ ] Optional: vor dem Upload einmal durchsehen

## 4. Signieren & hochladen
- [ ] Android: Upload-Keystore + `android/key.properties` (siehe README), `flutter build appbundle`
- [x] iOS ohne Xcode: Cloud-Build über Codemagic, Anleitung in `CODEMAGIC.md` (erster Build ok)
- [ ] TestFlight auf dem iPhone testen, dann Build in Version 1.0 wählen und einreichen
      (alternativ mit Xcode: Team wählen, `flutter build ipa`, Upload per Transporter)
- [ ] Texte aus `fastlane/metadata/` und Datenschutz-Antworten aus `fastlane/STORE.md` eintragen
