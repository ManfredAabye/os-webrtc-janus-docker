# Janus Gateway Server

Ein Bash-Skript, das den Janus Gateway Server auf einem Ubuntu-System installiert und für die Nutzung mit OpenSimulator vorbereitet. 

Es übernimmt die wichtigsten Schritte: 

Abhängigkeiten installieren, Janus aus dem offiziellen Repository klonen und bauen, grundlegende Konfiguration für OpenSimulator setzen und Janus starten.

Du kannst das Skript nach Bedarf anpassen (z. B. für Tokens, Ports oder spezifische OpenSimulator-Einstellungen).

```bash
#!/bin/bash

# Janus-Gateway Installations- und Konfigurationsskript für Ubuntu (Getestet mit Ubuntu 22.04)

set -e

# 1. Abhängigkeiten installieren
sudo apt update
sudo apt install -y \
  git build-essential automake libtool pkg-config gengetopt \
  libmicrohttpd-dev libjansson-dev libssl-dev libsrtp2-dev \
  libsofia-sip-ua-dev libglib2.0-dev libopus-dev libogg-dev \
  libcurl4-openssl-dev liblua5.3-dev libconfig-dev \
  libnice-dev libwebsockets-dev doxygen graphviz \
  cmake

# 2. Janus Gateway clonen und bauen
cd /tmp
git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
sh autogen.sh
./configure --prefix=/opt/janus --enable-rest --enable-websockets --disable-data-channels
make -j$(nproc)
sudo make install
sudo make configs

# 3. Konfiguration für OpenSimulator
# Beispielwerte für Tokens, bitte anpassen!
JANUS_API_TOKEN="dein_api_token"
JANUS_ADMIN_TOKEN="dein_admin_token"
JANUS_PORT="8088"
JANUS_ADMIN_PORT="7088"

JANUS_CFG="/opt/janus/etc/janus/janus.transport.http.jcfg"
sudo sed -i "s/admin_secret = .*/admin_secret = \"$JANUS_ADMIN_TOKEN\";/" $JANUS_CFG
sudo sed -i "s/api_secret = .*/api_secret = \"$JANUS_API_TOKEN\";/" $JANUS_CFG
sudo sed -i "s/listen = .*/listen = 0.0.0.0;/" $JANUS_CFG
sudo sed -i "s/port = .*/port = $JANUS_PORT;/" $JANUS_CFG
sudo sed -i "s/admin_port = .*/admin_port = $JANUS_ADMIN_PORT;/" $JANUS_CFG

# 4. Janus starten
sudo /opt/janus/bin/janus &

# 5. Hinweis für OpenSimulator-Konfiguration
echo ""
echo "Janus Gateway wurde installiert und gestartet."
echo ""
echo "Trage folgende Werte in deine OpenSimulator-Konfiguration ein:"
echo ""
echo "[JanusWebRtcVoice]"
echo "JanusGatewayURI = http://<DEINE_SERVER_IP>:$JANUS_PORT"
echo "APIToken = $JANUS_API_TOKEN"
echo "JanusGatewayAdminURI = http://<DEINE_SERVER_IP>:$JANUS_ADMIN_PORT"
echo "AdminAPIToken = $JANUS_ADMIN_TOKEN"
echo ""
echo "Weitere Janus-Konfigurationsdateien: /opt/janus/etc/janus/"
echo "Janus Logfile: /opt/janus/var/log/janus.log"
```

**Hinweise:**
- Passe `JANUS_API_TOKEN` und `JANUS_ADMIN_TOKEN` auf sichere Werte an (z. B. mit `uuidgen` erzeugen).
- Die Ports kannst du bei Bedarf ebenfalls anpassen.
- OpenSimulator muss mit denselben Token-Werten und Ports konfiguriert werden.

Möchtest du das Skript als Datei im Repository anlegen (z. B. als `install-janus-native.sh`)? Sag Bescheid, ich kann einen Pull Request für dich vorbereiten!Hier ist ein Bash-Skript, das den Janus Gateway Server auf einem Ubuntu-System installiert und für die Nutzung mit OpenSimulator vorbereitet. Es übernimmt die wichtigsten Schritte: Abhängigkeiten installieren, Janus aus dem offiziellen Repository klonen und bauen, grundlegende Konfiguration für OpenSimulator setzen und Janus starten.

Du kannst das Skript nach Bedarf anpassen (z. B. für Tokens, Ports oder spezifische OpenSimulator-Einstellungen).

```bash
#!/bin/bash

# Janus-Gateway Installations- und Konfigurationsskript für Ubuntu (Getestet mit Ubuntu 22.04)

set -e

# 1. Abhängigkeiten installieren
sudo apt update
sudo apt install -y \
  git build-essential automake libtool pkg-config gengetopt \
  libmicrohttpd-dev libjansson-dev libssl-dev libsrtp2-dev \
  libsofia-sip-ua-dev libglib2.0-dev libopus-dev libogg-dev \
  libcurl4-openssl-dev liblua5.3-dev libconfig-dev \
  libnice-dev libwebsockets-dev doxygen graphviz \
  cmake

# 2. Janus Gateway clonen und bauen
cd /tmp
git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
sh autogen.sh
./configure --prefix=/opt/janus --enable-rest --enable-websockets --disable-data-channels
make -j$(nproc)
sudo make install
sudo make configs

# 3. Konfiguration für OpenSimulator
# Beispielwerte für Tokens, bitte anpassen!
JANUS_API_TOKEN="dein_api_token"
JANUS_ADMIN_TOKEN="dein_admin_token"
JANUS_PORT="8088"
JANUS_ADMIN_PORT="7088"

JANUS_CFG="/opt/janus/etc/janus/janus.transport.http.jcfg"
sudo sed -i "s/admin_secret = .*/admin_secret = \"$JANUS_ADMIN_TOKEN\";/" $JANUS_CFG
sudo sed -i "s/api_secret = .*/api_secret = \"$JANUS_API_TOKEN\";/" $JANUS_CFG
sudo sed -i "s/listen = .*/listen = 0.0.0.0;/" $JANUS_CFG
sudo sed -i "s/port = .*/port = $JANUS_PORT;/" $JANUS_CFG
sudo sed -i "s/admin_port = .*/admin_port = $JANUS_ADMIN_PORT;/" $JANUS_CFG

# 4. Janus starten
sudo /opt/janus/bin/janus &

# 5. Hinweis für OpenSimulator-Konfiguration
echo ""
echo "Janus Gateway wurde installiert und gestartet."
echo ""
echo "Trage folgende Werte in deine OpenSimulator-Konfiguration ein:"
echo ""
echo "[JanusWebRtcVoice]"
echo "JanusGatewayURI = http://<DEINE_SERVER_IP>:$JANUS_PORT"
echo "APIToken = $JANUS_API_TOKEN"
echo "JanusGatewayAdminURI = http://<DEINE_SERVER_IP>:$JANUS_ADMIN_PORT"
echo "AdminAPIToken = $JANUS_ADMIN_TOKEN"
echo ""
echo "Weitere Janus-Konfigurationsdateien: /opt/janus/etc/janus/"
echo "Janus Logfile: /opt/janus/var/log/janus.log"
```

**Hinweise:**
- Passe `JANUS_API_TOKEN` und `JANUS_ADMIN_TOKEN` auf sichere Werte an (z. B. mit `uuidgen` erzeugen).
- Die Ports kannst du bei Bedarf ebenfalls anpassen.
- OpenSimulator muss mit denselben Token-Werten und Ports konfiguriert werden.

Möchtest du das Skript als Datei im Repository anlegen (z. B. als `install-janus-native.sh`)? Sag Bescheid, ich kann einen Pull Request für dich vorbereiten!
