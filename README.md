# KISterne – KI-Workshop Setup

Automatisches Setup-Script für den Workshop **„Von 0 auf KI in 4 Abenden"**  
von [Andreas Kammerer, CMC](https://kammerer.at) · Navigating the Age of AI

## Schnellstart

Auf dem Hetzner-Server als root ausführen:

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
| Server | Hetzner CX23 oder größer · Ubuntu 22.04/24.04/26.04 |
| OpenRouter | Account + API Key + mind. EUR 10 Guthaben |
| Telegram | Bot-Token von @BotFather |
| Kosten | ca. EUR 4,79/Monat (Hetzner) + Verbrauch (OpenRouter) |

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

Basiert auf [Hermes Agent](https://github.com/NousResearch/hermes-agent) von NousResearch · MIT License
