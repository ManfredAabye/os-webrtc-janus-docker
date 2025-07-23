# os-webrtc-janus-docker

Dieses Projekt dient dem Erstellen und Ausführen eines [Janus-Gateway]-Dienstes zur Unterstützung von WebRTC-basiertem Voice in [OpenSimulator]. Es wird in Verbindung mit [os-webrtc-janus] verwendet, einem Addon-Modul für [OpenSimulator].

Dieses Projekt erstellt ein [Docker]-Image von [Janus-Gateway] mit Konfigurationsskripten für eine einfache Einrichtung bei der Nutzung mit [os-webrtc-janus].

Das [Janus-Gateway]-Image kann entweder mit dem zentralen Grid-Service (Robust-Server) oder zusammen mit einem Regionensimulator für lokalen, räumlichen Voice-Betrieb verwendet werden. Siehe die Dokumentation von [os-webrtc-janus] für Details zur Konfiguration von [OpenSimulator].

Da [OpenSimulator] sowohl regionale, räumliche Voice-Kommunikation als auch gridweite Gruppen-Sprachkanäle hat, kann dieser Voice-Server sowohl mit dem Regionensimulator als auch mit dem zentralen Grid-Server betrieben werden. Es gibt somit zwei mögliche Setups:

- Der zentrale Grid-Service betreibt einen [Janus]-Server, der alle Voice-Nutzung im Grid unterstützt
- Eine Region betreibt einen [Janus]-Server, der den lokalen, räumlichen Voice-Service für diese Region bereitstellt.

HINWEIS: Stand Dezember 2024 bietet dies noch keinen räumlichen Voice-Support für [OpenSimulator]. Dieses Feature muss noch durch Änderungen am [Janus]-Dienst hinzugefügt werden (Änderung der AudioBridge, damit sie den Datenkanal liest und die Stereoeinstellungen der Kanäle anpasst). Das ist ein zukünftiges Projekt.

Anleitungen für:

- [Docker-Image bauen](#Building)
- [Konfiguration](#Configuration)
- [Docker-Image unter Linux ausführen](#Docker_Linux)
- [Docker-Image unter Windows mit WSL ausführen](#Docker_WSL)

<a id="Building"></a>
## ERSTELLEN

Ein möglicher Ablauf ist, das Repository auf den Docker-Server zu klonen, die Dateien `env` und `secrets` zu bearbeiten, das [Janus]-Image zu bauen und dann auszuführen. So wird das Janus Docker-Image auf dem Rechner erstellt und mit Ihrer Konfiguration gestartet.

Wenn Docker auf Ihrem Linux-System installiert ist, lauten die Schritte:

```
git clone https://github.com/Misterblue/os-webrtc-janus-docker
cd os-webrtc-janus-docker
# "secrets" mit API-Keys bearbeiten
./build-janus.sh
./run-janus.sh
```

`build-janus.sh` baut das lokale Docker-Image und  
`run-janus.sh` konfiguriert die Konfigurationsdatei und startet das Docker-Image.

Für das Bauen unter Windows gab es einige Versuche, aber [Janus] hat sehr viele Paketabhängigkeiten und diese Versuche waren nicht erfolgreich. Am besten nutzt man das Windows Subsystem for Linux (WSL), das eine Standarderweiterung für Windows ist. Unten gibt es Anweisungen für WSL.

Die Skripte bauen nur für die Architektur "X86_64".  
Wenn Sie erfolgreich für andere Architekturen bauen, erstellen Sie bitte ein Issue oder einen Pull Request, damit Ihre Lösung integriert werden kann.

<a id="Configuration"></a>
## KONFIGURATION

Es gibt zwei Dateien, `env` und `secrets`, die alle üblichen Konfigurationseinstellungen enthalten. Das Verzeichnis `etc/janus` enthält alle unveränderten [Janus]-Konfigurationsdateien aus der Distribution. Wenn `run-janus.sh` ausgeführt wird, werden die Werte in den Konfigurationsdateien je nach Inhalt von `env` und `secrets` aktualisiert. Sie können die [Janus]-Konfigurationsdateien auch manuell anpassen.

#### OPENSIMULATOR-KONFIGURATION

[OpenSimulator] verwendet die [Janus]-API, daher müssen in der Janus-Konfiguration lediglich die API-Passwörter gesetzt werden. Verwenden Sie die gleichen Passwörter in der Janus-`secrets`-Datei und in den INI-Konfigurationsdateien auf dem Regions-/Grid-Server.

Beispiel für die `secrets`-Datei auf dem Janus-Server:

```
# Geheime Parameter für den Betrieb von Janus
# Dies sind üblicherweise Zugriffstoken und werden durch das Skript updateConfiguration.sh in die Konfigurationsdateien eingefügt.
# DAS SIND GEHEIMNISSE!!!!
# NIEMALS, NIEMALS, NIEMALS EINCHECKEN!!!

JS_ADMIN_TOKEN=cde086df-bab3-446d-9af1-50714eacb405
JS_API_TOKEN=63f54171-7f8a-44bb-8f6b-532a0f1c3204
```

Und auf dem [OpenSimulator]-Server, `bin/config/os-webrtc-janus.ini` z.B.:

```
[WebRtcVoice]
    Enabled=true
    SpacialVoiceService=WebRtcJanusService.dll:WebRtcJanusService
    NonSpacialVoiceService=WebRtcJanusService.dll:WebRtcJanusService

[JanusWebRtcVoice]
    JanusGatewayURI=http://janus.example.org:14223/voice
    APIToken=cde086df-bab3-446d-9af1-50714eacb405
    JanusGatewayAdminURI=http://janus.example.org:14225/voiceAdmin
    AdminAPIToken=63f54171-7f8a-44bb-8f6b-532a0f1c3204
```

Die API-Tokens sind einfache Zeichenfolgen und können fast beliebig gewählt werden. Im Beispiel habe ich eindeutige GUIDs generiert (Linux-Befehl `uuidgen`).

Siehe [os-webrtc-janus] für Details zur [OpenSimulator]-Einrichtung.

<a id="Docker_Linux"></a>
## Docker-Image unter Linux ausführen

Installieren Sie die Docker-Engine auf Ihrem Linux-System. Sie können das Paketmanagementsystem Ihrer Distribution verwenden oder den Anweisungen unter  
[https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/) folgen.

Mit installiertem Docker klonen Sie dieses Repository und bauen das Image:

```
# Repository klonen
git clone https://github.com/Misterblue/os-webrtc-janus-docker.git
cd os-webrtc-janus-docker

# Janus-Gateway-Image bauen
./build-janus.sh
# Das gebaute Image kann mit "docker images" angezeigt werden

# Konfigurationsdateien bearbeiten
#   "env" muss wahrscheinlich nicht geändert werden
#   "secrets" benötigt neue API-Tokens (zufällige UUIDs mit 'uuidgen' generieren)

# Janus-Image in einem neuen Container starten
./run-janus.sh
```

<a id="Docker_WSL"></a>
## Docker-Image unter Windows mit WSL ausführen

Das Janus Docker-Image kann mit dem Windows Subsystem for Linux (WSL) ausgeführt werden. Dies beinhaltet die Installation von WSL2 auf Ihrem Windows-System und anschließend entweder die Installation von Docker in einer WSL2-Instanz oder die Nutzung von [Docker Desktop].

#### WSL

Microsoft bietet Anweisungen zur Installation und Einrichtung von WSL unter  
[https://learn.microsoft.com/en-us/windows/wsl/setup/environment](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)  
Ich verwende die Ubuntu-Distributionen, aber Sie können auch andere wählen.

Im 'cmd'-Fenster:

```
# WSL auf Ihrem Windows-System installieren
c:\Users\Me> wsl --install -d Ubuntu-24.04

# Eine Linux-Instanz starten und die Konsole zu dieser Instanz wechseln (Sie befinden sich nun in Linux)
c:\Users\Me> ubuntu

# Initiale Kontoinfos einrichten. Den Anweisungen folgen.

# Updates für die Ubuntu-Distribution installieren
$ sudo apt-get update && apt-get upgrade -y

# Docker auf dem Ubuntu WSL-Image installieren
# Anleitungen unter https://docs.docker.com/engine/install/ubuntu/
# Einfache Installationsvariante:
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh

# Repository klonen
$ git clone https://github.com/Misterblue/os-webrtc-janus-docker.git
$ cd os-webrtc-janus-docker

# Janus-Gateway-Image bauen
$ ./build-janus.sh
# Das gebaute Image kann mit "docker images" angezeigt werden

# Konfigurationsdateien bearbeiten
#   "env" muss wahrscheinlich nicht geändert werden
#   "secrets" benötigt neue API-Tokens (zufällige UUIDs mit 'uuidgen' generieren)

# Janus-Image in einem neuen Container starten
$ ./run-janus.sh

# Diese Sitzung beenden. Der Janus Docker-Container läuft weiter.
$ exit
   
C:\Users\Me>
```

Mit dem 'cmd'-Befehl `docker ps` können Sie das laufende Docker-Image anzeigen.

Sie können jederzeit in das Linux-Image wechseln und den laufenden Docker-Container verwalten. Die Skripte `stop-janus.sh` oder `restart-janus.sh` können so ausgeführt werden:

```
c:\Users\Me> ubuntu
$ cd os-webrtc-janus-docker
$ ./stop-janus.sh
$ exit
c:\Users\Me>
```

Viele hilfreiche Informationen zu Docker und Windows gibt es in [Austin Tate's Blog] unter  
[Windows Subsystem for Linux – LSL – Resources].

#### Docker Desktop

[Docker Desktop] ist eine Benutzeroberfläche und ein Docker-Laufzeitsystem, das WSL für das Ausführen von Docker-Containern verwendet.  
Es ist praktisch, da es eine grafische Oberfläche für das zugrunde liegende Docker-System bietet und Sie einfach die laufenden Images sehen und verwalten können.  
Durch die Installation von [Docker Desktop] werden die Docker-Befehle auch in 'cmd'-Fenstern verfügbar.

Folgen Sie den Anweisungen unter  
[https://docs.docker.com/desktop/setup/install/windows-install/](https://docs.docker.com/desktop/setup/install/windows-install/)  
um Docker Desktop zu installieren.

Nach der Installation können Sie das Janus Docker-Image wie oben beschrieben bauen und ausführen und anschließend den laufenden Container mit der Docker Desktop UI verwalten.

[Docker]: https://www.docker.com/  
[Docker Desktop]: https://docs.docker.com/desktop/  
[OpenSimulator]: http://opensimulator.org  
[WebRTC]: https://webrtc.org/  
[Janus]: https://janus.conf.meetecho.com/  
[Janus-Gateway]: https://janus.conf.meetecho.com/  
[os-webrtc-janus]: https://github.com/Misterblue/os-webrtc-janus  
[Windows Subsystem for Linux – LSL – Resources]: https://blog.inf.ed.ac.uk/atate/2024/12/31/wsl-resources/  
[Austin Tate's Blog]: https://blog.inf.ed.ac.uk/atate/  

---
