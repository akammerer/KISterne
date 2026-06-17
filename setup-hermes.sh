#!/bin/bash
# =============================================================================
#  HERMES AGENT SETUP SCRIPT
#  Von 0 auf KI – Workshop "Gruber Haustechnik" Demo + Teilnehmer-Version
#  Getestet auf: Ubuntu 22.04 LTS sowie Debian 12/13 (apt-basiert, x86_64 & ARM64)
# =============================================================================

set -euo pipefail

# ── Farben für die Ausgabe ────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $1"; }
info() { echo -e "${BLUE}→${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC}  $1"; }
step() { echo -e "\n${BOLD}${BLUE}══ $1 ══${NC}"; }
fail() { echo -e "${RED}✗ FEHLER:${NC} $1"; exit 1; }

banner() {
  echo -e "${BOLD}"
  echo "╔═══════════════════════════════════════════════════╗"
  echo "║        HERMES AGENT – AUTOMATISCHES SETUP          ║"
  echo "║         Von 0 auf KI · Workshop-Script             ║"
  echo "╚═══════════════════════════════════════════════════╝"
  echo -e "${NC}"
}

# ── Eingabe immer vom Terminal lesen ──────────────────────────────────
# Wichtig: Das Script wird per 'curl ... | bash' gestartet. Dabei ist die
# Standard-Eingabe die Pipe (das Script selbst), NICHT die Tastatur.
# Darum lesen wir Eingaben explizit von /dev/tty.
ask() {  # ask "Frage: " VARNAME
  local prompt="$1" __var="$2" __val=""
  read -rp "$prompt" __val < /dev/tty
  printf -v "$__var" '%s' "$__val"
}

# ── Voraussetzungen prüfen ────────────────────────────────────────────
check_root() {
  if [[ $EUID -ne 0 ]]; then
    fail "Dieses Script muss als root ausgeführt werden. Bitte mit 'sudo bash setup-hermes.sh' starten."
  fi
}

check_os() {
  # Akzeptiert Debian- und Ubuntu-basierte Systeme (beide nutzen apt).
  local ID="" ID_LIKE="" PRETTY_NAME=""
  [[ -r /etc/os-release ]] && . /etc/os-release
  if [[ "${ID:-}" == "ubuntu" || "${ID:-}" == "debian" \
        || "${ID_LIKE:-}" == *debian* || "${ID_LIKE:-}" == *ubuntu* ]]; then
    ok "Betriebssystem erkannt: ${PRETTY_NAME:-${ID:-unbekannt}}"
    return 0
  fi
  # Kein interaktives Abbruch-Prompt (würde unter 'curl | bash' sofort beenden).
  warn "Weder Debian noch Ubuntu erkannt (${PRETTY_NAME:-unbekannt}). Script ist für apt-basierte Systeme gedacht – Setup wird trotzdem versucht."
}

# ── System aktualisieren ──────────────────────────────────────────────
update_system() {
  step "System aktualisieren"
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -qq
  apt-get upgrade -y -qq
  # xz-utils: auf Debian-minimal nicht vorinstalliert, wird aber zum Entpacken
  # der Node.js-Pakete (.tar.xz) durch den Hermes-Installer benötigt.
  apt-get install -y -qq curl git ca-certificates unzip xz-utils tar
  ok "System aktuell"
}

# ── Hermes Agent installieren ─────────────────────────────────────────
install_hermes() {
  step "Hermes Agent installieren"
  info "Lade Installer von NousResearch..."
  curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
  # PATH für diese Session aktualisieren
  export PATH="$HOME/.local/bin:$HOME/.hermes/bin:$PATH"
  source ~/.bashrc 2>/dev/null || true
  if ! command -v hermes &>/dev/null; then
    # Versuche typische Installationspfade
    for p in "$HOME/.local/bin/hermes" "$HOME/.hermes/bin/hermes"; do
      [[ -f "$p" ]] && { export PATH="$(dirname $p):$PATH"; break; }
    done
  fi
  command -v hermes &>/dev/null || fail "Hermes-Installation fehlgeschlagen. Bitte manuell prüfen."
  ok "Hermes $(hermes --version 2>/dev/null || echo 'installiert')"
}

# ── OpenRouter konfigurieren ──────────────────────────────────────────
configure_openrouter() {
  step "OpenRouter API konfigurieren"
  echo ""
  echo "  Du brauchst einen OpenRouter Account und einen API Key."
  echo "  → https://openrouter.ai  (Account anlegen, dann API Keys → Create Key)"
  echo "  Lade mindestens 10 EUR auf, damit der Key funktioniert."
  echo ""
  while true; do
    ask "  OpenRouter API Key (beginnt mit sk-or-...): " OR_KEY
    [[ "$OR_KEY" =~ ^sk-or- ]] && break
    warn "  Ungültiges Format – muss mit 'sk-or-' beginnen."
  done
  hermes config set OPENROUTER_API_KEY "$OR_KEY"
  # Standardmodell: Claude 3.5 Haiku – günstig, schnell, fähig
  hermes config set model "anthropic/claude-3.5-haiku"
  ok "OpenRouter konfiguriert · Modell: claude-3.5-haiku"
}

# ── Telegram Bot einrichten ───────────────────────────────────────────
configure_telegram() {
  step "Telegram Bot einrichten"
  echo ""
  echo "  SCHRITT 1: Bot bei BotFather erstellen"
  echo "  ───────────────────────────────────────"
  echo "  1. Öffne Telegram auf deinem Handy"
  echo "  2. Suche nach: @BotFather"
  echo "  3. Tippe: /newbot"
  echo "  4. Wähle einen Namen für deinen Bot (z.B. 'Mein KI Assistent')"
  echo "  5. Wähle einen Username (muss auf 'bot' enden, z.B. 'MeinNameKI_bot')"
  echo "  6. BotFather schickt dir einen Token – kopiere ihn"
  echo ""
  ask "  Telegram Bot Token: " TG_TOKEN
  [[ -z "$TG_TOKEN" ]] && fail "Kein Token eingegeben."
  hermes config set TELEGRAM_BOT_TOKEN "$TG_TOKEN"

  echo ""
  echo "  SCHRITT 2: Deine Telegram User-ID herausfinden"
  echo "  ───────────────────────────────────────────────"
  echo "  1. Starte deinen neuen Bot in Telegram (suche nach dem Username)"
  echo "  2. Schicke ihm: /start"
  echo "  3. Öffne diese URL im Browser und ersetze DEIN_TOKEN:"
  echo "     https://api.telegram.org/botDEIN_TOKEN/getUpdates"
  echo "  4. Suche nach: \"id\": XXXXXXX – das ist deine User-ID"
  echo ""
  ask "  Deine Telegram User-ID (nur Zahlen): " TG_USER_ID
  [[ "$TG_USER_ID" =~ ^[0-9]+$ ]] || fail "User-ID muss nur aus Zahlen bestehen."
  hermes config set TELEGRAM_ALLOWED_USERS "$TG_USER_ID"
  ok "Telegram konfiguriert · User-ID: $TG_USER_ID"
}

# ── Als 24/7 Systemd-Service einrichten ──────────────────────────────
install_service() {
  step "Hermes als Hintergrunddienst einrichten"

  HERMES_BIN=$(command -v hermes)
  HERMES_USER="${SUDO_USER:-root}"
  HERMES_HOME=$(eval echo "~$HERMES_USER")

  cat > /etc/systemd/system/hermes-gateway.service << EOF
[Unit]
Description=Hermes Agent – Telegram Gateway
Documentation=https://hermes-agent.nousresearch.com
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$HERMES_USER
WorkingDirectory=$HERMES_HOME
ExecStart=$HERMES_BIN gateway
Restart=always
RestartSec=15
StandardOutput=journal
StandardError=journal
Environment=PATH=$HOME/.local/bin:$HOME/.hermes/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable hermes-gateway
  systemctl start hermes-gateway
  sleep 3

  if systemctl is-active --quiet hermes-gateway; then
    ok "Dienst läuft – Hermes startet automatisch nach jedem Neustart"
  else
    warn "Dienst gestartet aber Status unklar. Prüfe mit: systemctl status hermes-gateway"
  fi
}

# ── Abschlussinfo ─────────────────────────────────────────────────────
print_summary() {
  SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || echo "unbekannt")
  echo ""
  echo -e "${GREEN}${BOLD}"
  echo "╔═══════════════════════════════════════════════════╗"
  echo "║              SETUP ABGESCHLOSSEN!                  ║"
  echo "╚═══════════════════════════════════════════════════╝"
  echo -e "${NC}"
  echo "  Server-IP:       $SERVER_IP"
  echo "  Modell:          anthropic/claude-3.5-haiku (via OpenRouter)"
  echo "  Telegram:        aktiv – schick /start an deinen Bot!"
  echo ""
  echo "  Nützliche Befehle:"
  echo "  ─────────────────────────────────────────────────"
  echo "  hermes doctor              → Diagnose wenn etwas nicht klappt"
  echo "  hermes model               → Modell wechseln"
  echo "  hermes gateway status      → Gateway-Status prüfen"
  echo "  systemctl status hermes-gateway → Service-Status"
  echo "  journalctl -u hermes-gateway -f → Live-Logs anzeigen"
  echo ""
  echo "  Dokumentation: https://hermes-agent.nousresearch.com/docs"
  echo ""
}

# ── Hauptprogramm ─────────────────────────────────────────────────────

main() {
  banner
  check_root
  check_os
  update_system
  install_hermes
  configure_openrouter
  configure_telegram
  install_service
  print_summary
}

main "$@"
