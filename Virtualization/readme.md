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
