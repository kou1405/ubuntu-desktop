#!/bin/bash

# Configuration des couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=======================================================${NC}"
echo -e "${BLUE}   UBUNTU DESKTOP PRO - VERSION ULTRA-STABLE (GCP)     ${NC}"
echo -e "${BLUE}=======================================================${NC}"

# 1. Nettoyage
echo -e "${GREEN}[1/5] Nettoyage des sessions...${NC}"
vncserver -kill :1 || true
vncserver -kill :2 || true
rm -rf /tmp/.X1-lock /tmp/.X2-lock /tmp/.X11-unix/X1 /tmp/.X11-unix/X2 || true

# 2. Installation (Navigateur léger + correctifs)
echo -e "${GREEN}[2/5] Installation du navigateur stable et léger...${NC}"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 xfce4-goodies \
    tightvncserver websockify novnc \
    dbus-x11 x11-xserver-utils \
    epiphany-browser mousepad terminator \
    at-spi2-core

# 3. Configuration de l'environnement
echo -e "${GREEN}[3/5] Configuration du bureau...${NC}"
mkdir -p ~/.vnc
echo "manus123" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export GTK_A11Y=none
startxfce4
EOF
chmod +x ~/.vnc/xstartup

# 4. Lancement du serveur graphique
echo -e "${GREEN}[4/5] Démarrage du serveur graphique...${NC}"
vncserver :2 -geometry 1280x720 -depth 24

# 5. Lancement du proxy Web (NoVNC)
echo -e "${GREEN}[5/5] Démarrage du portail Web...${NC}"
pkill -f websockify || true
python3 -m websockify --web /usr/share/novnc 6080 localhost:5902 &

echo -e "${BLUE}=======================================================${NC}"
echo -e "${GREEN}   BUREAU PRÊT - NAVIGATION WEB STABLE                 ${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo -e "1. Ouvrez votre onglet ${BLUE}vnc.html${NC}"
echo -e "2. Connectez-vous avec le mot de passe : ${GREEN}manus123${NC}"
echo -e "3. Pour internet, utilisez le navigateur ${GREEN}'Web' (Epiphany)${NC} dans le menu."
echo -e "${BLUE}=======================================================${NC}"
