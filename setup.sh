#!/bin/bash

# Mettre à jour et installer les dépendances
echo "Installation du bureau Ubuntu (XFCE) et de NoVNC..."
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 xfce4-goodies tightvncserver websockify novnc

# Configurer VNC
echo "Configuration de VNC..."
mkdir -p ~/.vnc
echo "manus123" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

cat <<EOF > ~/.vnc/xstartup
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# Démarrer VNC
vncserver -kill :1 || true
vncserver :1 -geometry 1280x720 -depth 24

# Démarrer NoVNC
echo "Démarrage de NoVNC sur le port 6080..."
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

echo "-------------------------------------------------------"
echo "VOTRE BUREAU UBUNTU EST PRÊT !"
echo "-------------------------------------------------------"
echo "1. Cliquez sur le bouton 'Aperçu sur le Web' (icône en haut à droite)."
echo "2. Sélectionnez 'Modifier le port' et entrez : 6080"
echo "3. Une fois la page ouverte, entrez le mot de passe : manus123"
echo "-------------------------------------------------------"
