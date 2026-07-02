#!/bin/bash
# 🚀 Von 0 auf KI — Harness Setup (Linux/Mac)
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HERMES_SKILLS="${HOME}/.hermes/skills"

echo "🚀 Von 0 auf KI — Harness Setup"
echo "================================"
echo ""

# 1. Check Hermes
if [ ! -d "$HOME/.hermes" ]; then
    echo "❌ Hermes scheint nicht installiert zu sein."
    echo "   Installiere zuerst: https://hermes-agent.nousresearch.com"
    exit 1
fi
echo "✅ Hermes gefunden"

# 2. Check USER.md
if [ ! -f "$REPO_DIR/USER.md" ]; then
    echo "❌ USER.md nicht gefunden! Bitte zuerst ausfüllen."
    exit 1
fi

if grep -q "Max Mustermann" "$REPO_DIR/USER.md"; then
    echo "⚠️  USER.md enthält noch Beispiel-Daten (Max Mustermann)!"
    echo "   Bitte trage Deine eigenen Daten ein."
    echo ""
    read -p "Trotzdem fortfahren? (j/N) " choice
    if [ "$choice" != "j" ] && [ "$choice" != "J" ]; then
        echo "❌ Setup abgebrochen."
        exit 0
    fi
fi

# 3. Skills dir
mkdir -p "$HERMES_SKILLS"

# 4. Copy skills
echo ""
echo "📦 Kopiere Skills..."

for skill in assistent unternehmens-berater versicherungs-pruefer gesundheit-wache; do
    src="$REPO_DIR/skills/$skill"
    dst="$HERMES_SKILLS/$skill"
    if [ -d "$dst" ]; then
        echo "   ⚠️  Skill '$skill' existiert bereits — überschreibe..."
        rm -rf "$dst"
    fi
    cp -r "$src" "$dst"
    echo "   ✅ Skill '$skill' installiert"
done

# 5. Copy AGENTS.md
cp "$REPO_DIR/AGENTS.md" "$HERMES_SKILLS/AGENTS.md" 2>/dev/null || true
echo ""

echo "✅ Installation abgeschlossen!"
echo ""
echo "Starte Hermes neu und probier's aus:"
echo "   'Hilf mir bei der Unternehmensberatung'"
echo "   'Prüf meine Versicherungen'"
echo "   'Check meine Gesundheitsdaten'"