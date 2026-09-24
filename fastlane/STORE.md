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

**Apple „App-Datenschutz“:** „Keine Daten erfasst“. Die App lädt nichts aus dem Netz
(Schrift Inter ist gebündelt), Spracherkennung läuft über Apples eigenen Dienst und zählt
nicht als Erhebung durch dich.

**Google Play „Datensicherheit“:**
- Daten erhoben: Keine
- Daten geteilt: Keine
- Hinweis Audio: Spracheingabe verarbeitet der Android-Spracherkennungsdienst,
  die App speichert oder überträgt nichts
- Löschen möglich: Ja (Einträge löschen bzw. App deinstallieren)

## Links & Kontakt

Die Seiten liegen in `docs/` und laufen über GitHub Pages (einmalig aktivieren, s. README):

| Feld | Wert |
|---|---|
| Support-URL | https://ngsgg58794-lab.github.io/Kopfleeren/ |
| Datenschutz-URL | https://ngsgg58794-lab.github.io/Kopfleeren/privacy.html |
| Impressum | https://ngsgg58794-lab.github.io/Kopfleeren/impressum.html |
| Kontakt-E-Mail | mail@juliawimmer.de |
| Copyright (App Store) | 2026 Julia Wimmer |

In der App: Info-Symbol → Datenschutz / Support / Impressum / Lizenzen
(Apple verlangt den Datenschutz-Link auch in der App).

EU-Händlerstatus (Apple DSA-Abfrage / Play „Händler“): Wer die App kommerziell anbietet
(auch später mit Käufen), muss sich als Händler angeben – dann zeigen die Stores Name,
Anschrift und E-Mail öffentlich an.

## Screenshots

Pflichtgröße App Store: iPhone 6,9" (1320×2868, z. B. Simulator „iPhone 16 Pro Max“).
Die App ist nur fürs iPhone freigegeben → keine iPad-Screenshots nötig. Achtung: Apple
testet iPhone-Apps trotzdem auf dem iPad im Kompatibilitätsmodus – dort muss sie laufen.
Play: mind. 2 Handy-Screenshots (z. B. 1080×1920), dazu Feature-Grafik 1024×500.

Vorschlag (je DE + EN, mit kurzer Überschrift über dem Screenshot):
1. Gefüllte Liste nach Kategorien – „Kopf frei in Sekunden“ / „A clear mind in seconds“
2. Spracheingabe aktiv – „Einfach drauflos sprechen“ / „Just speak your mind“
3. Automatisch sortiert – „Calmdrop sortiert für dich“ / „Sorted for you“
4. Dunkelmodus – „Ruhig bei Tag und Nacht“ / „Calm day and night“
5. Sprachauswahl / „Alles erledigt“ – „Deutsch & Englisch“ / „Kopf ist frei“

## Weitere Pflichtfelder

- Play: Zielgruppe (nicht für Kinder unter 13 → einfacher), App-Zugriff „keine Anmeldung nötig“
