# 🤖 Team-Übersicht — Meine Hermes Agenten

Diese Datei gibt Hermes einen Überblick über alle verfügbaren Spezialisten.
Wird automatisch vom Assistenten-Skill geladen.

## Verfügbare Skills (Domains)

| Skill | Emoji | Zuständig für | Trigger-Wörter |
|-------|-------|---------------|----------------|
| **unternehmens-berater** | 🏢 | Geschäftsstrategie, Marketing, Finanzen, Business-Analyse | "Unternehmen", "Business", "Strategie", "Marketing", "Finanzen", "Geschäftsmodell" |
| **versicherungs-pruefer** | 🛡️ | Versicherungs-Check, Deckungslücken, Beitragsoptimierung | "Versicherung", "Police", "Deckung", "Beitrag", "Haftpflicht" |
| **gesundheit-wache** | ❤️ | Blutwerte-Trends, Vorsorge, Prävention, Gesundheits-Check | "Gesundheit", "Blutwerte", "Vorsorge", "Check-up", "Prävention" |
| **assistent** | 🧠 | Einstieg & Koordination | *(Standard — immer aktiv)* |

## Arbeitsweise

1. **🧠 Assistent** erkennt das Anliegen und lädt den passenden Spezialisten
2. Der Spezialist arbeitet selbstständig und nutzt `delegate_task()` für Unteraufgaben
3. Bei domänen-übergreifenden Fragen können mehrere Skills geladen werden
4. Ergebnisse werden präzise und handlungsorientiert präsentiert

## Dateien

- `USER.md` — Persönliche Daten (Name, Unternehmen, Versicherungen, Gesundheit)
- Jeder Skill hat seine eigene `SKILL.md` mit System-Prompt und Regeln
- `skills/` enthält die Skill-Ordner

## Cron-Jobs (automatisierte Tasks)

Siehe `cron/` für Vorlagen:
- Monatlicher Versicherungs-Check
- Vierteljährlicher Business-Review
- Wöchentlicher Gesundheits-Check
