#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=======================================================${NC}"
echo -e "${BLUE}   UBUNTU DESKTOP PRO - FIX FINAL NAVIGATEUR           ${NC}"
echo -e "${BLUE}=======================================================${NC}"

# 1. Nettoyage complet
echo -e "${GREEN}[1/5] Nettoyage des processus...${NC}"
vncserver -kill :1 || true
vncserver -kill :2 || true
pkill -f firefox || true
pkill -f epiphany || true
pkill -f websockify || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* || true

# 2. Installation des composants critiques
echo -e "${GREEN}[2/5] Installation des correctifs de rendu...${NC}"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 xfce4-goodies \
    tightvncserver websockify novnc \
    dbus-x11 x11-xserver-utils \
    epiphany-browser at-spi2-core \
    wmctrl

# 3. Configuration du démarrage (Correction DBUS & Sandbox)
echo -e "${GREEN}[3/5] Optimisation du démarrage graphique...${NC}"
mkdir -p ~/.vnc
echo "manus123" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
# Initialisation du bus de message (Crucial pour le navigateur)
if [ -z "\$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval \$(dbus-launch --sh-syntax --exit-with-session)
fi

export GTK_A11Y=none
export WEBKIT_FORCE_SANDBOX=0
export WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS=1

# Lancement du bureau
startxfce4 &

# Attendre un peu et forcer le lancement du navigateur en mode compatible
sleep 5
epiphany --new-window https://www.google.com &
EOF
chmod +x ~/.vnc/xstartup

# 4. Lancement du serveur graphique
echo -e "${GREEN}[4/5] Démarrage du serveur graphique...${NC}"
vncserver :2 -geometry 1280x720 -depth 24

# 5. Lancement du proxy Web NoVNC
echo -e "${GREEN}[5/5] Activation de l'accès Web...${NC}"
python3 -m websockify --web /usr/share/novnc 6080 localhost:5902 &

echo -e "${BLUE}=======================================================${NC}"
echo -e "${GREEN}   CORRECTION TERMINÉE !                               ${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo -e "1. Rafraîchissez votre page ${BLUE}vnc.html${NC}"
echo -e "2. Connectez-vous (`manus123`)."
echo -e "3. Le navigateur Google s'ouvrira ${GREEN}automatiquement${NC} après 5 secondes."
echo -e "${BLUE}=======================================================${NC}"
