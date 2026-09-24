# Store-Eintrag Calmdrop

Texte (DE/EN) liegen in `fastlane/metadata/` im fastlane-Format:
`fastlane deliver` (iOS) bzw. `fastlane supply` (Android) lädt sie hoch –
oder per Hand in App Store Connect / Play Console kopieren.

| Feld | Limit | Datei |
|---|---|---|
| App Store Name / Play Titel | 30 | `name.txt` / `title.txt` |
| App Store Untertitel | 30 | `subtitle.txt` |
| App Store Werbetext (jederzeit änderbar) | 170 | `promotional_text.txt` |
| App Store Keywords (Komma, keine Leerzeichen nötig) | 100 | `keywords.txt` |
| Play Kurzbeschreibung | 80 | `short_description.txt` |
| Beschreibung | 4000 | `description.txt` / `full_description.txt` |

Keywords wiederholen bewusst weder Name noch Untertitel (zählt Apple ohnehin).

## Einstufung

- **Kategorie:** Produktivität (sekundär: Lifestyle). Nicht „Gesundheit & Fitness“ –
  das zieht strengere Prüfung nach sich; Texte machen deshalb keine Gesundheitsversprechen.
- **Altersfreigabe:** Fragebogen überall „Nein“ → Apple 4+, Play USK 0 / PEGI 3.
- **Werbung:** keine. **In-App-Käufe:** keine (Stand jetzt).

## Datenschutz-Angaben

Stand des Codes: Aufgaben liegen nur lokal (`shared_preferences`), kein Konto,
kein Analytics, kein eigener Server.

**Apple „App-Datenschutz“:** „Keine Daten erfasst“ ist vertretbar, **wenn** die Schriften
gebündelt werden (siehe unten). Spracherkennung läuft über Apples eigenen Dienst
und zählt nicht als Erhebung durch dich.

**Google Play „Datensicherheit“:**
- Daten erhoben: Keine
- Daten geteilt: Keine
- Hinweis Audio: Spracheingabe wird vom Android-Spracherkennungsdienst verarbeitet,
  nicht von der App gespeichert oder übertragen
- Daten während der Übertragung verschlüsselt: Ja (nur Schrift-Download)
- Löschen möglich: Ja (App deinstallieren bzw. Einträge löschen)

**Offener Punkt – `google_fonts`:** lädt Inter beim ersten Start von Google-Servern
(IP-Adresse geht an Google). Für saubere „keine Daten“-Angaben und DSGVO:
Inter als Asset bündeln und `GoogleFonts.config.allowRuntimeFetching = false` setzen.

**Datenschutzerklärung:** Pflicht in beiden Stores (öffentliche URL). Entwurf siehe
`fastlane/privacy-policy.md` – vor Veröffentlichung Kontaktdaten ergänzen und
rechtlich prüfen lassen.

## Screenshots

Pflichtgrößen: iPhone 6,9" (1320×2868) – Apple skaliert für kleinere Geräte;
iPad nur, wenn iPad unterstützt wird (Flutter-Standard: ja → 13" 2064×2752 nötig,
alternativ iPad in Xcode abschalten). Play: mind. 2 Handy-Screenshots, dazu
Feature-Grafik 1024×500.

Vorschlag (je DE + EN, mit kurzer Überschrift über dem Screenshot):
1. Gefüllte Liste nach Kategorien – „Kopf frei in Sekunden“ / „A clear mind in seconds“
2. Spracheingabe aktiv – „Einfach drauflos sprechen“ / „Just speak your mind“
3. Automatisch sortiert – „Calmdrop sortiert für dich“ / „Sorted for you“
4. Dunkelmodus – „Ruhig bei Tag und Nacht“ / „Calm day and night“
5. Sprachauswahl / „Alles erledigt“ – „Deutsch & Englisch“ / „Kopf ist frei“

## Weitere Pflichtfelder

- Support-URL (App Store) und Kontakt-E-Mail (beide Stores)
- Datenschutz-URL
- App Store: Copyright-Zeile, z. B. „2026 <Dein Name>“
- Play: Zielgruppe (nicht für Kinder unter 13 → einfacher), App-Zugriff „keine Anmeldung nötig“
