#!/bin/bash

# Configuration des couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=======================================================${NC}"
echo -e "${BLUE}   UBUNTU DESKTOP PRO - VERSION STABLE (GCP)           ${NC}"
echo -e "${BLUE}=======================================================${NC}"

# 1. Nettoyage de sécurité
echo -e "${GREEN}[1/5] Nettoyage des sessions précédentes...${NC}"
vncserver -kill :1 || true
vncserver -kill :2 || true
rm -rf /tmp/.X1-lock /tmp/.X2-lock /tmp/.X11-unix/X1 /tmp/.X11-unix/X2 || true

# 2. Installation des dépendances (version optimisée)
echo -e "${GREEN}[2/5] Installation des composants essentiels...${NC}"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 xfce4-goodies \
    tightvncserver websockify novnc \
    dbus-x11 x11-xserver-utils \
    firefox mousepad terminator

# 3. Configuration du démarrage graphique
echo -e "${GREEN}[3/5] Configuration du bureau...${NC}"
mkdir -p ~/.vnc
echo "manus123" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4
EOF
chmod +x ~/.vnc/xstartup

# 4. Lancement du serveur graphique (Display :2 pour éviter les conflits)
echo -e "${GREEN}[4/5] Démarrage du serveur graphique...${NC}"
vncserver :2 -geometry 1280x720 -depth 24

# 5. Lancement du proxy Web (NoVNC)
echo -e "${GREEN}[5/5] Démarrage du portail Web...${NC}"
pkill -f websockify || true
python3 -m websockify --web /usr/share/novnc 6080 localhost:5902 &

echo -e "${BLUE}=======================================================${NC}"
echo -e "${GREEN}   VOTRE BUREAU EST PRÊT ET STABLE !                   ${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo -e "1. Cliquez sur 'Web Preview' -> 'Change Port' -> 6080"
echo -e "2. Dans la liste, cliquez sur ${GREEN}vnc.html${NC}"
echo -e "3. Mot de passe : ${GREEN}manus123${NC}"
echo -e "${BLUE}=======================================================${NC}"
