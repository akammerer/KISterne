# KISterne – KI-Workshop Setup

Automatisches Setup-Script für den Workshop **„Von 0 auf KI in 4 Abenden"**  
von [Andreas Kammerer, CMC](https://kammerer.at) · Navigating the Age of AI

## Schnellstart

Auf dem netcup-Server als root ausführen:

```bash
curl -fsSL https://raw.githubusercontent.com/akammerer/KISterne/main/setup-hermes.sh | bash
```

Das Script installiert und konfiguriert automatisch:
- **Hermes Agent** (NousResearch) – selbst-verbessernder KI-Assistent
- **OpenRouter** – Zugang zu 400+ KI-Modellen (API Key erforderlich)
- **Telegram Gateway** – Assistent direkt am Handy erreichbar
- **systemd Service** – läuft 24/7, startet automatisch nach Reboot

## Voraussetzungen

| Was | Details |
|---|---|
| Server | netcup VPS oder vergleichbar · Ubuntu 22.04/24.04/26.04 |
| OpenRouter | Account + API Key + mind. EUR 10 Guthaben |
| Telegram | Bot-Token von @BotFather |
| Kosten | ca. EUR 5/Monat (netcup) + Verbrauch (OpenRouter) |

## Was das Script tut

1. System aktualisieren (apt update/upgrade)
2. Hermes Agent installieren (via offizielles Install-Script)
3. OpenRouter API Key konfigurieren
4. Modell setzen: `anthropic/claude-3.5-haiku`
5. Telegram Bot Token + User-ID konfigurieren
6. Hermes als systemd-Service einrichten (autostart)

## Nützliche Befehle danach

```bash
hermes doctor              # Diagnose
hermes model               # Modell wechseln
hermes gateway status      # Telegram-Status
systemctl status hermes-gateway
journalctl -u hermes-gateway -f   # Live-Logs
```

## Workshop-Termine

| Abend | Datum | Thema |
|---|---|---|
| 1 | Mo, 15. Juni 2026 | KI erleben & einordnen |
| 2 | Mo, 29. Juni 2026 | Dein Server in der Euro-Cloud |
| 3 | Mo, 06. Juli 2026 | Dein Assistent lernt dein Business |
| 4 | Mo, 13. Juli 2026 | Praxis & Abschluss |

📍 Café Monika – schön hier, Peuerbach · 18:30 Uhr

---

## 🧠 Abend 3: Domain-Skills — Dein Assistent kann mehr

Nach der Installation hast Du drei **fertige Skills** die Deinen Hermes
zum Spezialisten für Dein Unternehmen machen:

| Skill | Emoji | Was er kann |
|-------|-------|-------------|
| **Assistent** | 🧠 | Erkennt automatisch worum es geht, lädt den richtigen Experten |
| **Unternehmens-Berater** | 🏢 | Geschäftsstrategie, Finanzen, Marketing, Prozesse |
| **Versicherungs-Prüfer** | 🛡️ | Deckungslücken finden, Beiträge optimieren |
| **Gesundheit-Wache** | ❤️ | Blutwerte-Trends, Vorsorge-Kalender, Prävention |

### Installation (nach dem Server-Setup)

```bash
# 1. USER.md mit eigenen Daten ausfüllen
nano USER.md

# 2. Skills kopieren
mkdir -p ~/.hermes/skills
cp -r skills/* ~/.hermes/skills/
cp AGENTS.md ~/.hermes/skills/

# 3. Hermes neustarten
systemctl restart hermes-gateway

# 4. Testen — schreib deinem Bot:
# "Hilf mir bei der Unternehmensberatung"
# "Prüf meine Versicherungen"
# "Check meine Gesundheitsdaten"
```

### 🔑 SSH-Key für VSCode (optional)

in `docs/ssh-key-guide.md`:
- SSH-Key erstellen
- Per VSCode Remote-SSH auf den Server verbinden
- Skills bequem editieren

### ⏰ Cron-Jobs automatisieren

in `cron/README.md`:
- Monatlicher Versicherungs-Check
- Vierteljährlicher Business-Review
- Wöchentlicher Gesundheits-Check

---

## 🗄️ Abend 4: Übungsdatenbank

`mini_erp.db` — SQLite-Datenbank für die MCP-Übung (Kunden, Artikel,
Rechnungen einer fiktiven Firma aus der Region Peuerbach).
Download: oben in der Dateiliste anklicken → „Download raw file",
dann nach `C:\Firma\` legen.

---

| Datei | Wofür? |
|-------|--------|
| `USER.md` | **Deine Daten** — trage Name, Firma, Versicherungen, Gesundheit ein |
| `AGENTS.md` | Team-Übersicht für den Assistenten |
| `skills/assistent/` | Einstiegs-Skill — erkennt die Domain |
| `skills/unternehmens-berater/` | Business-Analyse |
| `skills/versicherungs-pruefer/` | Versicherungs-Check |
| `skills/gesundheit-wache/` | Gesundheits-Monitoring |
| `mini_erp.db` | Übungsdatenbank für Abend 4 (MCP + SSH-Tunnel) |
| `setup.ps1` / `setup.sh` | Kopiert alles an den richtigen Ort |

---

*Abend 3 Teil: Skills & Personalisierung — jeder Teilnehmer passt die Skills an.*

Basiert auf [Hermes Agent](https://github.com/NousResearch/hermes-agent) von NousResearch · MIT License
