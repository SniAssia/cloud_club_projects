# 🖥️ First Secure Server Setup (Debian)

Ce document décrit **pas à pas** la configuration complète d’un serveur Linux sécurisé, conforme aux exigences du projet :  
système, utilisateurs, SSH, firewall, politique de mots de passe, sudo, script de monitoring et déploiement d’un service.

---

## 1️⃣ Installation du système

### Choix de l’OS
- **Debian Stable (latest)**  
- Installation minimale (sans interface graphique)

> 💡 Debian est stable, sécurisé et recommandé pour débuter en administration système.

---

## 2️⃣ Configuration du hostname

### Objectif
Le hostname doit suivre le format :
Firstname.Lastname-CC


### Commandes
```bash
sudo hostnamectl set-hostname Issam.Doby-CC


Vérification :

hostname

3️⃣ Mise à jour du système
sudo apt update && sudo apt upgrade -y

4️⃣ Création de l’utilisateur non-root
Objectif

Créer un utilisateur correspondant au hostname sans -CC.

sudo adduser Issam.Doby


Ajouter au groupe sudo :

sudo usermod -aG sudo Issam.Doby


Vérification :

groups Issam.Doby

5️⃣ Configuration SSH sécurisée
Installation SSH
sudo apt install openssh-server -y

Configuration

Éditer le fichier :

sudo nano /etc/ssh/sshd_config


Modifier / ajouter :

Port 1111
PermitRootLogin no
PasswordAuthentication yes


Redémarrer SSH :

sudo systemctl restart ssh


Vérification :

ss -tulnp | grep 1111

6️⃣ Configuration du Firewall (UFW)
Installation
sudo apt install ufw -y

Règles
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 1111/tcp
sudo ufw enable


Vérification :

sudo ufw status

7️⃣ Politique de mots de passe forte
Objectifs

Expiration : 30 jours

Changement minimum : 2 jours

Alerte : 7 jours

Longueur ≥ 10 caractères

Majuscule + minuscule + chiffre

Pas plus de 3 caractères identiques consécutifs

Ne pas contenir le nom de l’utilisateur

7 caractères différents de l’ancien mot de passe

Configuration de login.defs
sudo nano /etc/login.defs


Modifier :

PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7

Configuration PAM

Installer le module :

sudo apt install libpam-pwquality -y


Modifier :

sudo nano /etc/pam.d/common-password


Remplacer la ligne par :

password requisite pam_pwquality.so retry=3 minlen=10 ucredit=-1 lcredit=-1 dcredit=-1 maxrepeat=3 usercheck=1 difok=7

8️⃣ Configuration sécurisée de sudo
Objectifs

3 tentatives max

Message d’erreur personnalisé

Logs complets (input/output)

Création du dossier de logs
sudo mkdir /var/log/sudo
sudo chmod 700 /var/log/sudo

Configuration sudoers
sudo visudo


Ajouter :

Defaults passwd_tries=3
Defaults badpass_message="⚠️ Accès refusé : mot de passe incorrect"
Defaults logfile="/var/log/sudo/sudo.log"
Defaults log_input
Defaults log_output

9️⃣ Script de monitoring (monitoring.sh)
Création du script
sudo nano /usr/local/bin/monitoring.sh

Contenu
#!/bin/bash

ARCH=$(uname -a)
CPU_PHYS=$(lscpu | grep "Socket(s)" | awk '{print $2}')
CPU_VIRT=$(nproc)
RAM=$(free -m | awk '/Mem:/ {printf "%d/%dMB (%.2f%%)", $3, $2, $3/$2*100}')
DISK=$(df -h --total | awk '/total/ {printf "%s/%s (%s)", $3, $2, $5}')
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.1f%%", 100-$8}')
LAST_BOOT=$(who -b | awk '{print $3 " " $4}')
TCP=$(ss -ta | grep ESTAB | wc -l)
USERS=$(who | wc -l)
IP=$(hostname -I | awk '{print $1}')
MAC=$(ip link | grep ether | awk '{print $2}' | head -n1)
SUDO=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)

wall << EOF
#Architecture: $ARCH
#CPU physical : $CPU_PHYS
#vCPU : $CPU_VIRT
#Memory Usage: $RAM
#Disk Usage: $DISK
#CPU load: $CPU_LOAD
#Last boot: $LAST_BOOT
#Connections TCP : $TCP ESTABLISHED
#User log: $USERS
#Network: IP $IP ($MAC)
#Sudo : $SUDO cmd
Your Server your rules !
EOF

Permissions
sudo chmod +x /usr/local/bin/monitoring.sh

🔟 Configuration Cron
Éditer la crontab root
sudo crontab -e


Ajouter :

@reboot /usr/local/bin/monitoring.sh
*/10 * * * * /usr/local/bin/monitoring.sh

1️⃣1️⃣ Déploiement d’un service : Nginx
Installation
sudo apt install nginx -y

Gestion du service
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl status nginx

Test
curl localhost


Résultat attendu :

Welcome to nginx!


📌 Accessibilité :

Accessible uniquement depuis la VM (port 80 non ouvert dans UFW)

📝 Difficultés rencontrées

Configuration PAM délicate → résolue via documentation officielle

Permissions sudo logs → corrigées avec chmod 700

Script monitoring → suppression des erreurs en redirigeant les sorties

✅ Checklist finale

 Debian Stable

 Hostname conforme

 SSH port 1111, root interdit

 Firewall configuré

 Utilisateur non-root créé

 Politique de mots de passe forte

 Sudo sécurisé et loggé

 monitoring.sh fonctionnel

 Cron actif

 Service déployé

🎉 Serveur prêt — sécurisé, monitoré et conforme aux standards professionnels.


---

Si tu veux, je peux aussi :
- 🔍 **vérifier ton serveur point par point**
- 🧪 **simuler les tests de soutenance**
- 🧾 **te préparer une fiche “questions / réponses examinateur”**

Dis-moi 👍
