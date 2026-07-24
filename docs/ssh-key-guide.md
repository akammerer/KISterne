# 🔑 SSH-Key Einrichtung — Schritt-für-Schritt

Damit Du bequem per VSCode auf Deinen Hermes Server zugreifen kannst,
richtest Du einmalig SSH-Keys ein. Danach kein Passwort mehr nötig.

Das brauchst Du später auch um:
- Hermes auf dem Server zu administrieren
- Dateien per VSCode Remote-SSH zu bearbeiten
- Cron-Jobs und Skills von Deinem Notebook aus zu verwalten

---

## 🧰 Was Du brauchst

- **Windows-Notebook** — PowerShell **oder** Git Bash (beide funktionieren)
- **Zugang zu Deinem Server** (IP/Hostname + root-Passwort aktuell)
- **VSCode** mit **Remote-SSH Extension** (wir installieren das später)
- **GIT for Windows** https://gitforwindows.org/
---

## 📋 Schritt 1: SSH-Key erstellen (auf Deinem Notebook)

Öffne **Git Bash** (nicht CMD, nicht PowerShell):

```bash
# In Git Bash eingeben:
ssh-keygen -t ed25519 -C "mein-hermes-key"
```

**Was Du siehst:**
```
Generating public/private ed25519 key pair.
Enter file in which to save the key (/c/Users/[USER]/.ssh/id_ed25519):
```

→ **Einfach Enter drücken** (Default-Pfad ist perfekt)

```
Enter passphrase (empty for no passphrase):
```

→ **WICHTIG**: Lass das leer oder gib einen Satz ein den Du Dir merkst.
   Leer = bequemster Zugriff. Mit Passphrase = sicherer, nerviger.
   Für den Kurs: **einfach Enter** (leer lassen).

```
Your identification has been saved in /c/Users/[USER]/.ssh/id_ed25519
Your public key has been saved in /c/Users/[USER]/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:... mein-hermes-key
```

✅ **Geschafft!** Dein Schlüsselpaar ist jetzt in `~/.ssh/` gespeichert.

---

## 📋 Schritt 2: Public Key auf den Server kopieren

Jetzt muss Dein öffentlicher Schlüssel auf den Server. Dafür gibt's zwei Wege:

### Weg A — Einzeiler (empfohlen, falls ssh-copy-id verfügbar):

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@DEINE_SERVER_IP
```

→ Passwort eingeben (ein letztes Mal 😉)

### Weg B — Per Echo-Befehl (funktioniert in PowerShell UND Git Bash)

⚠️ **🔴 WICHTIG: Der Public Key muss als GANZE Zeile kopiert werden!**
Nicht nur der mittlere Teil — sonst klappts nicht!

**RICHTIG** (komplette Zeile):
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA..............2FPvj9KqV mein-hermes-key
├─────────┘               └───────────────┘        └─────────────┘
Typ "ssh-ed25519"       Der eigentliche Key        Kommentar (frei wählbar)
```

**FALSCH** (fehlender Typ + Kommentar → wird nicht akzeptiert!):
```
AAAAC3NzaC1lZDI1NTE5AAAA..............2FPvj9KqV
└────────────────────────────────────────────┘
Nur der Key — ohne "ssh-ed25519" und ohne "mein-hermes-key"
```

**So machst Du's richtig:**

```powershell
# 1. Auf dem Notebook: Den Public Key anzeigen
cat ~/.ssh/id_ed25519.pub
```

→ Gibt z.B. aus:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+R6+YYBjo+bsFSVZ9kry37nD5tGSJVrcJCbRDT+loP mein-hermes-key
```

**⚠️ Markiere die GESAMTE Zeile** (von `ssh-ed25519` bis `mein-hermes-key`) und kopiere sie.

```powershell
# 2. Mit SSH auf den Server verbinden
ssh root@DEINE_SERVER_IP
# ← root-Passwort eingeben

# 3. Auf dem Server: authorized_keys mit der kompletten Zeile anlegen
#    (hier den kopierten KEY einfügen — muss mit ssh-ed25519 beginnen)
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+R6+YYBjo+bsFSVZ9kry37nD5tGSJVrcJCbRDT+loP mein-hermes-key" > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh

# 4. Prüfen ob's komplett drin ist:
cat ~/.ssh/authorized_keys
# → Muss die GANZE Zeile zeigen, beginnend mit "ssh-ed25519 ..."

# 5. Ausloggen
exit
```

---

## 📋 Schritt 3: Testen ob's klappt

```bash
ssh root@DEINE_SERVER_IP
```

**Wenn alles klappt:** → Du bist OHNE Passwort eingeloggt 🎉

**Wenn nicht:** Wahrscheinlich muss SSH am Server Passwort-Auth noch aktiv lassen:
```bash
# Als root auf dem Server:
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
```
Danach nochmal testen.

---

## 📋 Schritt 4: VSCode Remote-SSH einrichten

**⚠️ Im Kurs machen wir das gemeinsam.** Das ist die Vorbereitung.

### 4.1 Extension installieren

1. VSCode öffnen
2. Links auf das **Extensions-Icon** (oder `Strg+Shift+X`)
3. Such nach **"Remote - SSH"**
4. Klick auf **Installieren** (von Microsoft)

### 4.2 SSH Config anlegen

VSCode liest Deine `~/.ssh/config` Datei. Leg sie an:

```bash
# In Git Bash:
nano ~/.ssh/config
```

Diesen Inhalt einfügen (Deine IP natürlich anpassen):

```
Host hermes-server
    HostName DEINE_SERVER_IP
    User root
    Port 22
    IdentityFile ~/.ssh/id_ed25519
```

Speichern: `Strg+O`, Enter. Beenden: `Strg+X`

### 4.3 Verbinden

1. Klick in VSCode unten links auf das **><** Icon (Remote-SSH)
2. Wähle **"Connect to Host..."**
3. Wähle **"hermes-server"**
4. Neues Fenster öffnet sich → verbunden! ✅

Jetzt kannst Du Dateien auf dem Server öffnen, bearbeiten und speichern
— als ob sie lokal wären.

---

## 📋 Schritt 5: Sicherheit — root-Login mit Passwort deaktivieren (optional)

⚠️ Erst machen, NACHDEM der SSH-Key funktioniert!

```bash
# Auf dem Server:
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd
```

**Testen:** Öffne ein NEUES Terminal und versuch `ssh root@DEINE_SERVER_IP`.
→ Es muss OHNE Passwort-Frage klappen!

> **⚠️ Warnung:** Wenn Du jetzt nach dem Passwort gefragt wirst,
> hast Du Dich ausgesperrt. Dann musst Du über die Server-Console
> (Webinterface Deines Hosters) eingreifen. Im Zweifel erst später machen.

---

## 🧠 Für Fortgeschrittene: SSH Config Spickzettel

```bash
# ~/.ssh/config — mehrere Server verwalten

Host kurs-vm
    HostName 123.123.123.123
    User root
    IdentityFile ~/.ssh/id_ed25519

Host z4-server
    HostName 192.168.1.100
    User anka
    Port 22
    IdentityFile ~/.ssh/id_ed25519

# Verbinden mit:
# ssh kurs-vm
# ssh z4-server
```

---

## ❌ Troubleshooting

**"Permission denied (publickey)"**
→ Public Key liegt falsch? `cat ~/.ssh/authorized_keys` auf dem Server prüfen

**"Connection refused"**
→ Server läuft nicht / falsche IP / Port 22 blockiert

**"Could not resolve hostname"**
→ Tippfehler in der IP/Hostname

**Key funktioniert lokal, aber nicht in VSCode**
→ VSCode muss denselben `~/.ssh/config` lesen. Prüf ob die Datei da ist.
→ Windows: `C:\Users\DEIN_USER\.ssh\config` — auch für VSCode!

---

## ✅ Checkliste

- [ ] SSH-Key erstellt (`~/.ssh/id_ed25519`)
- [ ] Public Key auf Server kopiert
- [ ] `ssh root@DEINE_SERVER_IP` funktioniert ohne Passwort
- [ ] VSCode Remote-SSH Extension installiert
- [ ] `~/.ssh/config` mit Server-Eintrag
- [ ] VSCode verbindet zum Server

---

*Teil des "Von 0 auf KI in 4 Abenden" Kurses — Sternenbetriebe*
