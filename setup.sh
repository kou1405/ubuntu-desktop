#!/bin/bash

# Mettre à jour et installer les dépendances manquantes
echo "Installation des composants système et du bureau Ubuntu..."
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 xfce4-goodies tightvncserver websockify novnc dbus-x11 x11-xserver-utils

# Nettoyer les anciennes sessions VNC
echo "Nettoyage des anciennes sessions..."
vncserver -kill :1 || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1 || true

# Configurer VNC
echo "Configuration de VNC..."
mkdir -p ~/.vnc
echo "manus123" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

cat <<EOF > ~/.vnc/xstartup
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# Démarrer VNC
echo "Démarrage du serveur graphique..."
vncserver :1 -geometry 1280x720 -depth 24

# Vérifier et démarrer NoVNC
echo "Démarrage de NoVNC sur le port 6080..."
pkill -f novnc_proxy || true
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

echo "-------------------------------------------------------"
echo "CORRECTION APPLIQUÉE ! VOTRE BUREAU EST PRÊT."
echo "-------------------------------------------------------"
echo "1. Retournez sur l'onglet du bureau (vnc.html)."
echo "2. Si c'est toujours gris, rafraîchissez la page (F5)."
echo "3. Cliquez sur 'Connect' et entrez : manus123"
echo "-------------------------------------------------------"
