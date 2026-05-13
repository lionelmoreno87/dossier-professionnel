#!/bin/bash
# ============================================================
# user_data.sh — Script d'initialisation automatique (CP1)
# Exécuté au PREMIER démarrage de l'instance EC2
# Coller ce contenu dans "Advanced Details > User Data" sur AWS
# ============================================================

# Journaliser toute l'exécution pour vérification ultérieure
exec > /var/log/user_data.log 2>&1
set -x

echo "=== Début initialisation : $(date) ==="

# --- 1. Mise à jour du système ---
apt-get update -y
apt-get upgrade -y

# --- 2. Installation de Nginx ---
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

# --- 3. Installation de Docker (méthode officielle) ---
apt-get install -y ca-certificates curl gnupg lsb-release

# Ajout de la clé GPG officielle Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Ajout du dépôt Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Démarrage et activation de Docker
systemctl enable docker
systemctl start docker

# Ajout de l'utilisateur ubuntu au groupe docker (sans sudo)
usermod -aG docker ubuntu

# --- 4. Page web personnalisée (preuve visuelle pour le DP) ---
cat > /var/www/html/index.html << 'HTML'
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Projet DevOps – TP Administrateur Système</title>
  <style>
    body { font-family: Arial, sans-serif; background: #1a1a2e; color: #eee; text-align: center; padding: 60px; }
    h1   { color: #00d4ff; font-size: 2.5em; }
    .box { background: #16213e; border: 2px solid #00d4ff; border-radius: 12px;
           display: inline-block; padding: 30px 50px; margin-top: 30px; }
    .ok  { color: #00ff88; font-weight: bold; }
  </style>
</head>
<body>
  <h1>🚀 Infrastructure Déployée Automatiquement</h1>
  <div class="box">
    <p><span class="ok">✅ Nginx</span> — Serveur web opérationnel</p>
    <p><span class="ok">✅ Docker</span> — Moteur de conteneurs installé</p>
    <p><span class="ok">✅ User Data</span> — Automatisation confirmée</p>
    <p style="color:#aaa; font-size:0.85em; margin-top:20px;">
      TP-01414 — Administrateur Système DevOps — Niveau 6
    </p>
  </div>
</body>
</html>
HTML

echo "=== Initialisation terminée avec succès : $(date) ==="
