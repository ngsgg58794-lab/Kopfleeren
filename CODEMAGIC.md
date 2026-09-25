# iOS-Build ohne Mac-Tools: Codemagic

Codemagic baut und signiert die App in der Cloud und lädt sie zu TestFlight hoch.
Konfiguration: `codemagic.yaml`. Kostenlos bis 500 Build-Minuten/Monat.

## 1. API-Key in App Store Connect erzeugen (einmalig)
1. appstoreconnect.apple.com → **Benutzer und Zugriff** → Reiter **Integrationen**
   → **App Store Connect API** → ggf. „Zugriff anfordern“ bestätigen
2. **Team-Schlüssel** → **+** → Name `Codemagic`, Zugriff **App-Manager** → Erstellen
3. Notieren: **Issuer ID** (oben) und **Key ID** (in der Zeile)
4. **API-Schlüssel laden** → `.p8`-Datei sicher speichern (geht nur **einmal**!)

## 2. Codemagic einrichten (einmalig)
1. codemagic.io → **Sign up with GitHub** → Zugriff auf das Repo `Kopfleeren` erlauben
2. **Add application** → GitHub → `ngsgg58794-lab/Kopfleeren` → Projekttyp **Flutter App**
3. Oben rechts **Teams** → dein Team → **Integrations** → **Developer Portal** → **Connect**
   - **App Store Connect API key name:** `calmdrop-asc` (genau so – steht in `codemagic.yaml`)
   - Issuer ID, Key ID und `.p8`-Datei aus Schritt 1 eintragen → **Save**
4. In der App → **Settings** → oben „**codemagic.yaml**“ als Konfiguration wählen
   (nicht den Workflow Editor)

## 3. Bauen
1. **Start new build** → Branch `claude/app-store-playstore-prep-drupfr`
   → Workflow **iOS → TestFlight** → **Start new build**
2. Nach ca. 15 Min.: Build ist in App Store Connect unter **TestFlight**
   (Apple verarbeitet danach noch 10–30 Min.)

Zertifikat und Provisioning-Profil erzeugt Codemagic automatisch über den API-Key.

## Wenn etwas schiefgeht
Im Build-Log den roten Schritt öffnen und die Fehlermeldung an Claude schicken.
