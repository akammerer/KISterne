# 🚀 Von 0 auf KI — Harness Setup (Windows PowerShell)
# Führt alle Installationen aus und kopiert die Skills an den richtigen Ort

$ErrorActionPreference = "Stop"
$RepoPath = $PSScriptRoot
$HermesSkillsPath = "$env:LOCALAPPDATA\hermes\skills"

Write-Host "🚀 Von 0 auf KI — Harness Setup" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# 1. Prüfen ob Hermes installiert ist
if (-not (Test-Path "$env:LOCALAPPDATA\hermes")) {
    Write-Host "❌ Hermes scheint nicht installiert zu sein." -ForegroundColor Red
    Write-Host "   Bitte installiere zuerst Hermes Agent von:" -ForegroundColor Yellow
    Write-Host "   https://hermes-agent.nousresearch.com" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Hermes gefunden in: $env:LOCALAPPDATA\hermes" -ForegroundColor Green

# 2. USER.md prüfen
$UserFile = Join-Path $RepoPath "USER.md"
if (-not (Test-Path $UserFile)) {
    Write-Host "❌ USER.md nicht gefunden!" -ForegroundColor Red
    Write-Host "   Bitte zuerst Deine Daten in USER.md eintragen." -ForegroundColor Yellow
    exit 1
}

# Prüfen ob Standard-Daten noch drin sind
$UserContent = Get-Content $UserFile -Raw
if ($UserContent -match "Max Mustermann") {
    Write-Host "⚠️  USER.md enthält noch die Beispieldaten (Max Mustermann)!" -ForegroundColor Yellow
    Write-Host "   Bitte trage Deine eigenen Daten ein, bevor Du fortfährst." -ForegroundColor Yellow
    Write-Host ""
    $choice = Read-Host "Trotzdem fortfahren? (j/N)"
    if ($choice -ne "j" -and $choice -ne "J") {
        Write-Host "❌ Setup abgebrochen. Editiere USER.md und starte neu." -ForegroundColor Red
        exit 0
    }
}

# 3. Hermes Skills-Verzeichnis prüfen / anlegen
if (-not (Test-Path $HermesSkillsPath)) {
    New-Item -ItemType Directory -Path $HermesSkillsPath -Force | Out-Null
    Write-Host "📁 Skills-Verzeichnis angelegt: $HermesSkillsPath" -ForegroundColor Green
}

# 4. Skills kopieren
Write-Host ""
Write-Host "📦 Kopiere Skills..." -ForegroundColor Cyan

$SkillsSource = Join-Path $RepoPath "skills"
$SkillsToInstall = @("assistent", "unternehmens-berater", "versicherungs-pruefer", "gesundheit-wache")

foreach ($Skill in $SkillsToInstall) {
    $Source = Join-Path $SkillsSource $Skill
    $Dest = Join-Path $HermesSkillsPath $Skill
    
    if (Test-Path $Dest) {
        Write-Host "   ⚠️  Skill '$Skill' existiert bereits — überschreibe..." -ForegroundColor Yellow
        Remove-Item -Path $Dest -Recurse -Force
    }
    
    Copy-Item -Path $Source -Destination $Dest -Recurse -Force
    Write-Host "   ✅ Skill '$Skill' installiert" -ForegroundColor Green
}

# 5. USER.md als globale Vorlage kopieren
$UserDest = Join-Path $HermesSkillsPath "USER.md"
$UserSource = Join-Path $RepoPath "USER.md"
$AgentSource = Join-Path $RepoPath "AGENTS.md"
$AgentDest = Join-Path $HermesSkillsPath "AGENTS.md"

# USER.md: am besten im Repo lassen, Hermes liest es aus dem Repo-Pfad
Write-Host ""
Write-Host "📄 USER.md verlinkt (bleibt im Repo-Verzeichnis)" -ForegroundColor Green

# AGENTS.md kopieren (Referenz für Skills)
if (Test-Path $AgentSource) {
    Copy-Item -Path $AgentSource -Destination $AgentDest -Force
    Write-Host "📄 AGENTS.md kopiert" -ForegroundColor Green
}

# 6. Cron-Jobs einrichten (optional)
$CronSource = Join-Path $RepoPath "cron"
if (Test-Path $CronSource) {
    Write-Host ""
    Write-Host "⏰ Vorbereitete Cron-Jobs gefunden:" -ForegroundColor Cyan
    Get-ChildItem $CronSource -Filter "*.md" | ForEach-Object {
        Write-Host "   📋 $($_.Name) — Infos in cron/$($_.Name)" -ForegroundColor Yellow
    }
    Write-Host "   Zum Aktivieren: hermes cronjob create ... (siehe README)" -ForegroundColor DarkGray
}

# 7. Fertig!
Write-Host ""
Write-Host "🎉 Installation abgeschlossen!" -ForegroundColor Green
Write-Host ""
Write-Host "Starte Hermes neu und probier's aus:" -ForegroundColor Cyan
Write-Host "   'Hilf mir bei der Unternehmensberatung'" -ForegroundColor White
Write-Host "   'Prüf meine Versicherungen'" -ForegroundColor White
Write-Host "   'Check meine Gesundheitsdaten'" -ForegroundColor White
Write-Host ""
Write-Host "📂 Deine USER.md mit persönlichen Daten liegt hier:" -ForegroundColor DarkGray
Write-Host "   $UserSource" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Skills können jederzeit angepasst werden:" -ForegroundColor DarkGray
Write-Host "   $HermesSkillsPath\{skill-name}\SKILL.md" -ForegroundColor DarkGray
