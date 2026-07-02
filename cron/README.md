# 📋 Cron-Job Vorlagen für den Universal Harness
# Zum Aktivieren in Hermes: hermes cronjob create ...
#
# Diese Jobs laufen automatisch und liefern regelmässige Updates.
# Passe sie an Deine Bedürfnisse an.

---

## 1. Monatlicher Versicherungs-Check
```bash
# Läuft am 1. jedes Monats um 9:00
hermes cronjob create \
  --name "versicherungs-check" \
  --schedule "0 9 1 * *" \
  --prompt "Lade den Versicherungs-Prüfer (skill_view('versicherungs-pruefer')) und führe einen Schnellcheck meines Versicherungs-Portfolios durch. Checke: Sind alle Deckungen aktuell? Gibt es neue Risiken? Was läuft in den nächsten 3 Monaten aus? USER.md für meine Daten verwenden." \
  --deliver origin
```

## 2. Vierteljährlicher Business-Review
```bash
# Läuft am 1. jedes Quartals (Jan, Apr, Jul, Okt) um 9:00
hermes cronjob create \
  --name "business-review" \
  --schedule "0 9 1 1,4,7,10 *" \
  --prompt "Lade den Unternehmens-Berater (skill_view('unternehmens-berater')) und führe einen kurzen Business-Review durch. Analysiere: aktuelle Geschäftssituation, offene Baustellen, Umsatz-Trends, nächste Schritte. USER.md für meine Unternehmensdaten verwenden. Max 500 Wörter." \
  --deliver origin
```

## 3. Wöchentlicher Gesundheits-Check (Montag 8:00)
```bash
hermes cronjob create \
  --name "gesundheits-check" \
  --schedule "0 8 * * 1" \
  --prompt "Lade die Gesundheit-Wache (skill_view('gesundheit-wache')) und führe einen kurzen Gesundheits-Check durch. Erinnere an: anstehende Vorsorge-Termine, Medikamenten-Einnahme, Impfungen. Checke ob neue Blutwerte eingegeben wurden. USER.md für meine Daten verwenden. Max 300 Wörter, bei nichts Neuem mit [SILENT] antworten." \
  --deliver origin
```

## 4. Jährlicher Strategie-Review (1. Januar)
```bash
hermes cronjob create \
  --name "strategie-review" \
  --schedule "0 9 1 1 *" \
  --prompt "Lade alle verfügbaren Skills (unternehmens-berater, versicherungs-pruefer, gesundheit-wache) und führe einen großen Jahres-Review durch. Was waren die Meilensteine? Was soll sich nächstes Jahr ändern? Ziele für das neue Jahr setzen. Max 1000 Wörter mit Prioritätenliste." \
  --deliver origin
```

---

## Tipp: Cron-Jobs testen

Starte einen Cron-Job sofort (ohne auf den Zeitplan zu warten):
```bash
hermes cronjob run --job-id <job-id>
```

Cron-Jobs auflisten:
```bash
hermes cronjob list
```

> **Hinweis:** Für Cron-Jobs wird ein Modell mit mindestens 64K Kontext benötigt (z.B. OpenRouter oder grosse lokale Modelle). Für einfache Erinnerungen ohne LLM-Analyse kann `no_agent=True` mit einem Script verwendet werden.