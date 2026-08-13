#!/bin/bash

# Configuration des couleurs pour un affichage pro
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=======================================================${NC}"
echo -e "${BLUE}   INSTALLATION UBUNTU DESKTOP PROFESSIONNEL (GCP)     ${NC}"
echo -e "${BLUE}=======================================================${NC}"

# 1. Mise à jour système et installation du bureau
echo -e "${GREEN}[1/4] Installation du bureau et des composants système...${NC}"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 xfce4-goodies \
    tightvncserver websockify novnc \
    dbus-x11 x11-xserver-utils \
    terminator \
    arc-theme papirus-icon-theme

# 2. Installation des applications professionnelles
echo -e "${GREEN}[2/4] Installation des applications (Navigateur, Bureautique...)${NC}"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    firefox \
    libreoffice \
    vlc \
    git curl wget \
    gimp \
    mousepad

# 3. Configuration de l'environnement VNC et Apparence
echo -e "${GREEN}[3/4] Configuration de l'interface utilisateur...${NC}"
mkdir -p ~/.vnc
echo "manus123" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Nettoyage des anciennes sessions
vncserver -kill :1 || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1 || true

cat <<EOF > ~/.vnc/xstartup
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XKL_XMODMAP_DISABLE=1
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# 4. Lancement des services
echo -e "${GREEN}[4/4] Démarrage des services...${NC}"
vncserver :1 -geometry 1920x1080 -depth 24

# Démarrage de NoVNC sur le port 6080
pkill -f novnc_proxy || true
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

echo -e "${BLUE}=======================================================${NC}"
echo -e "${GREEN}   VOTRE BUREAU PROFESSIONNEL EST PRÊT !               ${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo -e "1. Rafraîchissez votre onglet 'vnc.html'"
echo -e "2. Cliquez sur 'Connect' et utilisez le mot de passe : ${GREEN}manus123${NC}"
echo -e "3. Profitez de Firefox, LibreOffice et de votre bureau complet."
echo -e "${BLUE}=======================================================${NC}"
